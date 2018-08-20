//
//  HyperlootGUIView.m
//  Quake3
//
//  Created by valery_vaskabovich on 8/19/18.
//

#import "HyperlootGUIView.h"
#import "HyperlootManager.h"
#import "TransactionsDataSource.h"
#import "Quake3-Swift.h"

@interface HyperlootGUIView()

@property (nonatomic, weak) IBOutlet UIButton* walletAddressButton;
@property (nonatomic, weak) IBOutlet UIButton* redeemRocketLauncher;
@property (nonatomic, weak) IBOutlet UIButton* redeemInvisibility;
@property (nonatomic, weak) IBOutlet UIButton* redeemQuad;
@property (nonatomic, weak) IBOutlet UIView* redeemItemsContainerView;
@property (nonatomic, weak) IBOutlet UIButton* helpButton;
@property (nonatomic, weak) IBOutlet UITableView* transactionsTableView;

@property (nonatomic, weak) IBOutlet UIView* helpView;
@property (nonatomic, weak) IBOutlet UIButton* closeHelpButton;
@property (nonatomic, weak) IBOutlet UIButton* createNewWalletButton;


@property (nonatomic, strong) TransactionsDataSource* dataSource;

@end

@implementation HyperlootGUIView

+ (instancetype)guiView {
	
	UINib* nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
	NSArray* views = [nib instantiateWithOwner:nil options:nil];
	HyperlootGUIView* view = views.firstObject;
	
	if (view == nil || [view isKindOfClass: [self class]] == NO) {
		return [[HyperlootGUIView alloc] init];
	}
	
	return view;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self configureTableView];
}

- (void)start {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWalletInformation) name:kTestWalletUpdateNotification object:nil];
	[self updateWalletInformation];
}

- (void)updateWalletInformation {
	[self.walletAddressButton setTitle:HyperlootManager.shared.userName forState:UIControlStateNormal];
	self.redeemRocketLauncher.hidden = [HyperlootManager.shared hasItem:HLTokenItemTypeRocketLauncher] == NO;
	self.redeemQuad.hidden = [HyperlootManager.shared hasItem:HLTokenItemTypeQuadDamage] == NO;
	self.redeemInvisibility.hidden = [HyperlootManager.shared hasItem:HLTokenItemTypeInvisibility] == NO;
	
	[self.transactionsTableView reloadData];
}

#pragma mark - Actions

- (void)configureTableView {
	self.dataSource = [[TransactionsDataSource alloc] init];	
	[self.dataSource configureTableView:self.transactionsTableView];
}

- (IBAction)copyWalletAddress:(id)sender {
	NSString* address = [HyperlootManager shared].walletAddress;
	if (address.length > 0) {
		[[UIPasteboard generalPasteboard] setString: address];
	}
}

- (IBAction)redeemItems:(UIButton*)sender {
	[HyperlootManager.shared redeemItem:(HLTokenItemType)sender.tag];
}

- (IBAction)showHelp:(id)sender {
	self.helpView.hidden = NO;
}

- (IBAction)closeHelp:(id)sender {
	self.helpView.hidden = YES;
}

- (void)setHelpButtonsEnabled:(BOOL)value {
	self.closeHelpButton.enabled = value;
	self.createNewWalletButton.enabled = value;
}

- (IBAction)createNewWalletButtonPressed:(id)sender {
	__weak typeof(self) weakSelf = self;
	[self setHelpButtonsEnabled:NO];
	[HyperlootManager.shared createNewWallet:^(NSString * address) {
		[weakSelf updateWalletInformation];
		[weakSelf setHelpButtonsEnabled:YES];
		[weakSelf.helpView setHidden:YES];
	}];
}

@end
