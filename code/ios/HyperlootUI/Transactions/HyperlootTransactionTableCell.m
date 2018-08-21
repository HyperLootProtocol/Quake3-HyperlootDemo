//
//  HyperlootTransactionTableCell.m
//  Quake3
//
//  Created by valery_vaskabovich on 8/19/18.
//

#import "HyperlootTransactionTableCell.h"

@interface HyperlootTransactionTableCell ()

@property (nonatomic, weak) IBOutlet UILabel* transactionIdLabel;

@end

NSString* const kHLTransactionCellIdentifier = @"kHLTransactionCellIdentifier";

@implementation HyperlootTransactionTableCell

- (void)updateWithTransactionHash:(NSString*)hash {
	self.transactionIdLabel.text = hash.lowercaseString;
}

@end
