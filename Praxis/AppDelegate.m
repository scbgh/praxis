#import "AppDelegate.h"
#import "PXEditCodeViewController.h"
#import "PXDefaultBuiltins.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  PXInitBuiltins();

  UIViewController *rootViewController = [PXEditCodeViewController new];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

  self.window.rootViewController = navigationController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}


@end