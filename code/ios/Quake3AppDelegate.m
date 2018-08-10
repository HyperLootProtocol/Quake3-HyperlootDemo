/*
 * Quake3 -- iOS Port
 *
 * Seth Kingsley, January 2008.
 */

#import	"Quake3AppDelegate.h"
#import "MainViewController.h"
#import "HyperlootManager.h"

@implementation Quake3AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	[[HyperlootManager shared] launchWithCompletion:^(NSString * address) {
		NSLog(@"%@", address);
	}];
	
    return YES;
}

- (Q3ScreenView *)screenView {
    MainViewController* mainViewController = (MainViewController*)self.window.rootViewController;
    return mainViewController.screenView;
}

- (float)deviceRotation {
    MainViewController* mainViewController = (MainViewController*)self.window.rootViewController;
    return mainViewController.deviceRotation;
}

- (void)presentErrorMessage:(NSString *)errorMessage {
    MainViewController* mainViewController = (MainViewController*)self.window.rootViewController;
    [mainViewController presentErrorMessage:errorMessage];
}

- (void)presentWarningMessage:(NSString *)warningMessage {
    MainViewController* mainViewController = (MainViewController*)self.window.rootViewController;
    [mainViewController presentWarningMessage:warningMessage];
}


@end
