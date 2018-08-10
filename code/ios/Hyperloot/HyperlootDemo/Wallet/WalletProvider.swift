//
//  WalletProvider.swift
//  Hyperloot-iOS
//

import Foundation
import TrustCore

class WalletProvider {
 
    public weak var delegate: WalletUpdatesDelegate?
    
    private let keystore: EtherKeystore
    
    required init(keystore: EtherKeystore) {
        self.keystore = keystore
    }
    
    public func loadWallet(completion: @escaping ((WalletInfo?, Error?) -> Void)) {
        if let wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first {
            completion(wallet, nil)
        } else {
            createNewWallet(completion: completion)
        }
    }
    
    public func createNewWallet(completion: @escaping ((WalletInfo?, Error?) -> Void)) {
        let password = PasswordGenerator.generateRandom()
        keystore.createAccount(with: password) { [weak self] result in
            switch result {
            case .success(let account):
                self?.keystore.exportMnemonic(account: account) { [weak self] mnemonicResult in
                    guard let strongSelf = self else {
                        return
                    }
                    let w = Wallet(type: .hd(account))
                    let wallet = WalletInfo(wallet: w, info: WalletObject.from(w))
                    let initialName = "Wallet #\(strongSelf.keystore.wallets.count)"
                    strongSelf.keystore.store(object: wallet.info, fields: [.name(initialName)])
                    completion(wallet, nil)
                }
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }
    
    public func deleteWallet(completion: @escaping () -> Void) {
        guard let wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first else {
            return
        }
        
        keystore.delete(wallet: wallet.wallet) { (_) in
            completion()
        }
    }
}
