//
//  Q3TokenItem.swift
//  Quake3
//

import Foundation

@objc(Q3TokenItem)
public class Q3TokenItem: NSObject {
	
	let address: String
	let balance: String
	
	@objc
	required public init(address: String, balance: String) {
		self.address = address
		self.balance = balance
	}
	
	@objc public func numberOfOwnedItems() -> Double {
		return balance.doubleValue
	}
	
	@objc public func numberOfPendingItems() -> Double {
		guard let previousBalance = UserDefaults.standard.string(forKey: self.address) as String? else {
			return 0
		}
		return balance.doubleValue - previousBalance.doubleValue
	}
	
	@objc public func redeemItems() -> Bool {
		let numberOfItems = numberOfPendingItems()
		guard numberOfItems > 0 else {
			return false
		}
		
//		UserDefaults.standard.set(balance, forKey: self.address)
//		UserDefaults.standard.synchronize()
//		
		return true
	}
}
