//
//  HyperlootTransactionTableCell.h
//  Quake3
//
//  Created by valery_vaskabovich on 8/19/18.
//

#import <UIKit/UIKit.h>

extern NSString* const kHLTransactionCellIdentifier;

@interface HyperlootTransactionTableCell : UITableViewCell

- (void)updateWithTransactionHash:(NSString*)hash;

@end
