//
//  HyperlootTokenBalance.swift
//  Hyperloot-TestApp
//

import Foundation

@objc(HLHyperlootTokenBalance)
public class HyperlootTokenBalance: NSObject {
    @objc public var balance: String
    @objc public var address: String
    
    public init(address: String, balance: String) {
        self.balance = balance
        self.address = address
    }
}
