//
//  HyperlootDemo.swift
//  Hyperloot-iOS
//

import Foundation
import RealmSwift

@objc(HyperlootDemo)
public class HyperlootDemo: NSObject {
    
    struct Constants {
        static let balanceTimerInterval: TimeInterval = 30.0
    }
	
	@objc
    public static let shared = HyperlootDemo()
    
    public weak var delegate: WalletUpdatesDelegate?
    
    private let walletProvider: WalletProvider
    private let config = Config(defaults: UserDefaults.standard)
    
    private var balanceTimer = HyperlootTimer()
    
    private var session: HyperlootSession?
    
    private override init() {
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)
        walletProvider = WalletProvider(keystore: keystore)
    }
	
	@objc
    public func stop() {
        balanceTimer.stop()
    }
	
	@objc
    public func reset() {
        walletProvider.deleteWallet { [weak self] in
            self?.walletProvider.createNewWallet(completion: { [weak self] (walletInfo, error) in
                if let walletInfo = walletInfo, error == nil {
                    self?.createSession(account: walletInfo, delegate: self?.delegate)
                }
            })
        }
    }
	
	@objc
	public func launch(delegate: WalletUpdatesDelegate?, completion: @escaping ((String) -> Void)) {
        self.delegate = delegate
        walletProvider.loadWallet { [weak self] (walletInfo, error) in
            if let walletInfo = walletInfo, error == nil {
                self?.createSession(account: walletInfo, delegate: delegate)
            }
			let address: String = walletInfo?.address.eip55String ?? ""
			completion(address)
        }
    }
    
    private func createSession(account: WalletInfo, delegate: WalletUpdatesDelegate?) {
        let session = HyperlootSession(account: account)
        session.delegate = delegate
        session.update()
        
        self.session = session
        
        balanceTimer.start(timeInterval: Constants.balanceTimerInterval) { [weak self] in
            self?.session?.update()
        }
    }
}
