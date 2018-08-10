//
//  WalletUpdatesDelegate.swift
//  Hyperloot-iOS
//

import Foundation

@objc(HLWalletUpdatesDelegate)
public protocol WalletUpdatesDelegate: class {
    func update(balances: [HyperlootTokenBalance])
}
