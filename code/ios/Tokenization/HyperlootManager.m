//
//  HyperlootManager.m
//  Quake3
//

#import "HyperlootManager.h"
#import "Quake3-Swift.h"

#import "HyperlootWeapons.h"

static NSString* kHLQ3TokenAddress = @"0xa025879A4b5aC5524699f0d097736A7f6cE18c68";

@interface HyperlootManager () <HLWalletUpdatesDelegate>

@property (nonatomic, copy, readwrite) NSString* walletAddress;
@property (nonatomic, readwrite) NSString* userName;
@property (nonatomic, strong) Q3TokenItem* tokenItem;
@property (nonatomic, strong, readwrite) NSArray* transactions;

@end

NSString* const kTestWalletUpdateNotification = @"kTestWalletUpdateNotification";

@implementation HyperlootManager

+ (instancetype)shared {
	static HyperlootManager* manager = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		manager = [[self alloc] init];
	});
	
	return manager;
}

- (void)launchWithCompletion:(void(^)(NSString*))completion {
	__weak typeof(self) weakSelf = self;
	
	[HyperlootDemo.shared launchWithDelegate:self completion:^(NSString * _Nonnull address) {
		weakSelf.userName = HyperlootDemo.shared.walletName;
		weakSelf.walletAddress = address;
		completion(address);
	}];
}

- (void)createNewWallet:(void(^)(NSString*))completion {
	__weak typeof(self) weakSelf = self;
	
	[HyperlootDemo.shared resetWithCompletion:^(NSString * _Nonnull address) {
		weakSelf.userName = HyperlootDemo.shared.walletName;
		weakSelf.walletAddress = address;
		[weakSelf reset];
		completion(address);
	}];
}

- (void)reset {
	self.transactions = @[];
	self.tokenItem = nil;
}

- (double)numberOfItems {
	return self.tokenItem.numberOfOwnedItems / 10.0;
}

- (BOOL)hasItem:(HLTokenItemType)type {
	return (NSInteger)self.numberOfItems >= (NSInteger)type + 1;
}

- (void)redeemItem:(HLTokenItemType)type {
	switch (type) {
		case HLTokenItemTypeRocketLauncher:
			LoadTokenizedRocketLauncher();
			break;
			
		case HLTokenItemTypeInvisibility:
			LoadTokenizedInvisibility();
			break;
			
		case HLTokenItemTypeQuadDamage:
			LoadTokenizedQuadDamage();
			break;
	}
}

#pragma mark - HLWalletUpdatesDelegate

- (void)updateWithBalances:(NSArray<HLHyperlootTokenBalance *> *)balances {
	[balances enumerateObjectsUsingBlock:^(HLHyperlootTokenBalance * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj.address isEqualToString: kHLQ3TokenAddress]) {
			self.tokenItem = [[Q3TokenItem alloc] initWithAddress:obj.address balance:obj.balance];
			*stop = YES;
		}
	}];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kTestWalletUpdateNotification object:nil];
}

- (void)updateWithTransactions:(NSArray<HLHyperlootTransaction *> *)transactions {
	NSMutableArray* hlq3ContractTransactions = [NSMutableArray array];
	[transactions enumerateObjectsUsingBlock:^(HLHyperlootTransaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj.to.lowercaseString isEqualToString:kHLQ3TokenAddress.lowercaseString]) {
			[hlq3ContractTransactions addObject: obj];
		}
	}];
	
	self.transactions = [NSArray arrayWithArray:hlq3ContractTransactions];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kTestWalletUpdateNotification object:nil];
}

@end
