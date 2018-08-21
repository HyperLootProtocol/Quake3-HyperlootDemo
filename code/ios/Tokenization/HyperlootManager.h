//
//  HyperlootManager.h
//  Quake3
//
//  Created by valery_vaskabovich on 8/9/18.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HLTokenItemType) {
	HLTokenItemTypeRocketLauncher,
	HLTokenItemTypeQuadDamage,
	HLTokenItemTypeInvisibility
};

extern NSString* const kTestWalletUpdateNotification;

@interface HyperlootManager : NSObject

@property (nonatomic, readonly) NSString* walletAddress;
@property (nonatomic, readonly) NSString* userName;
@property (nonatomic, readonly) double numberOfItems;

@property (nonatomic, strong, readonly) NSArray* transactions;

+ (instancetype)shared;
- (void)launchWithCompletion:(void(^)(NSString*))completion;
- (void)createNewWallet:(void(^)(NSString*))completion;

- (BOOL)hasItem:(HLTokenItemType)type;

- (void)redeemItem:(HLTokenItemType)type;

@end
