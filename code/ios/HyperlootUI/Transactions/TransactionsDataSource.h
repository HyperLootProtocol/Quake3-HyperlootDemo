//
//  TransactionsDataSource.h
//  Quake3
//
//  Created by valery_vaskabovich on 8/19/18.
//

#import <UIKit/UIKit.h>

@interface TransactionsDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

- (void)configureTableView:(UITableView*)tableView;

@end
