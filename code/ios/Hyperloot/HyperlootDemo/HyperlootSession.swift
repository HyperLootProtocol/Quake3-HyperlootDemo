//
//  HyperlootSession.swift
//  Hyperloot-iOS
//

import Foundation
import RealmSwift
import TrustCore
import PromiseKit

class HyperlootSession {
    
    let config = Config(defaults: UserDefaults.standard)
    
    let account: WalletInfo
    let realm: Realm
    let sharedRealm: Realm
    
    lazy var walletStorage = WalletStorage(realm: sharedRealm)
    lazy var tokensNetwork: NetworkProtocol = {
        return TrustNetwork(provider: TrustProviderFactory.makeProvider(),
                            APIProvider: TrustProviderFactory.makeAPIProvider(),
                            balanceService: TokensBalanceService(),
                            account: account.wallet,
                            config: config
        )
    } ()
    
    lazy var tokensStore = TokensDataStore(realm: realm, config: config)
    
    lazy var walletSession: WalletSession = {
        let balanceCoordinator = BalanceCoordinator(account: account.wallet, config: config, storage: tokensStore)
        return WalletSession(account: account,
                             config: config,
                             balanceCoordinator: balanceCoordinator,
                             nonceProvider: GetNonceProvider(storage: transactionsStorage))
        
    } ()
    
    let transactionsStorage: TransactionsStorage
    
    lazy var tokens: Results<TokenObject> = {
        return tokensStore.tokens
    } ()
    
    var tokensObserver: NotificationToken?
    
    public weak var delegate: WalletUpdatesDelegate?
    
    init(account: WalletInfo) {
        self.account = account
        
        let migration = MigrationInitializer(account: account.wallet, chainID: config.chainID)
        migration.perform()
        
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        
        realm = try! Realm(configuration: migration.config)
        sharedRealm = try! Realm(configuration: sharedMigration.config)
        
        transactionsStorage = TransactionsStorage(realm: realm, account: account.wallet)
        transactionsStorage.removeTransactions(for: [.failed, .unknown])
        
        startObservingTokenUpdates()
    }
    
    func startObservingTokenUpdates() {
        tokensObserver = tokens.observe { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            var balances: [HyperlootTokenBalance] = []
            strongSelf.tokensStore.objects.forEach {
                let balance = $0.value
                let address = $0.address.eip55String
                balances.append(HyperlootTokenBalance(address: address, balance: balance))
            }
            
            strongSelf.delegate?.update(balances: balances)
        }
    }
    
    private func realm(for config: Realm.Configuration) -> Realm {
        return try! Realm(configuration: config)
    }
    
    public func update() {
        let address = account.address
        firstly {
            tokensNetwork.tokensList(for: address)
            }.done { [weak self] tokens in
                self?.tokensStore.update(tokens: tokens, action: .updateInfo)
            }.catch { error in
                NSLog("tokensInfo \(error)")
            }.finally { [weak self] in
                guard let strongSelf = self else { return }
                let tokens = strongSelf.tokensStore.objects
                strongSelf.balances(for: tokens)
        }
    }
    
    private func balances(for tokens: [TokenObject]) {
        let operationQueue: OperationQueue = OperationQueue()
        operationQueue.qualityOfService = .background
        
        let balancesOperations = Array(tokens.lazy.map { TokenBalanceOperation(network: self.tokensNetwork, address: $0.address, store: self.tokensStore) })
        operationQueue.addOperations(balancesOperations, waitUntilFinished: false)
    }
}
