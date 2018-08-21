//
//  HyperlootTransaction.swift
//  Quake3
//
//  Created by valery_vaskabovich on 8/19/18.
//

import Foundation

@objc(HLHyperlootTransaction)
public class HyperlootTransaction: NSObject {
	@objc public let transactionHash: String
	@objc public let from: String
	@objc public let to: String
	@objc public let value: String
	
	@objc
	init(transactionHash: String, from: String, to: String, value: String) {
		self.transactionHash = transactionHash
		self.from = from
		self.to = to
		self.value = value
	}
}
