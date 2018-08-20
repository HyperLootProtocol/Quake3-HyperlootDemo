//
//  TransactionsDataSource.m
//  Quake3
//
//  Created by valery_vaskabovich on 8/19/18.
//

#import "TransactionsDataSource.h"
#import "HyperlootTransactionTableCell.h"
#import "HyperlootManager.h"

#import "Quake3-Swift.h"

@implementation TransactionsDataSource

- (void)configureTableView:(UITableView*)tableView {
	[tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HyperlootTransactionTableCell class]) bundle:nil]
	forCellReuseIdentifier:kHLTransactionCellIdentifier];
	tableView.delegate = self;
	tableView.dataSource = self;
}

- (NSURL*)etherscanURLAtIndex:(NSInteger)index {
	HLHyperlootTransaction* transaction = HyperlootManager.shared.transactions[index];
	NSString* address = [NSString stringWithFormat:@"https://rinkeby.etherscan.io/tx/%@", transaction.transactionHash];
	return [NSURL URLWithString:address];
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[[UIApplication sharedApplication] openURL:[self etherscanURLAtIndex:indexPath.row] options:@{} completionHandler:nil];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return HyperlootManager.shared.transactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	HyperlootTransactionTableCell* cell = (HyperlootTransactionTableCell*)[tableView dequeueReusableCellWithIdentifier:kHLTransactionCellIdentifier forIndexPath:indexPath];
	if (cell) {
		HLHyperlootTransaction* transaction = HyperlootManager.shared.transactions[indexPath.row];
		[cell updateWithTransactionHash:transaction.transactionHash];
	}
	return cell;
}


@end
