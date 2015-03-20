//
//  AppDelegate.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/2/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "AppDelegate.h"
#import "KivaClientO.h"
#import "LoginViewController.h"
#import "LoansViewController.h"
#import "TeamSearchViewController.h"
#import "LoansSearchViewController.h"
#import "MySummaryViewController.h"
#import "UpdatesViewController.h"
#import "ProfileViewController.h"
#import "MapViewController.h"
#import "CRGradientNavigationBar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    TeamSearchViewController *teamSearchViewController = [[TeamSearchViewController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    
    LoansSearchViewController *loansSearchViewController = [[LoansSearchViewController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    
    UINavigationController *myNVC = [[UINavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    myNVC.viewControllers = @[[MySummaryViewController new]];
    
    UINavigationController *updatesViewController = [[UINavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    updatesViewController.viewControllers = @[[UpdatesViewController new]];
    
    UINavigationController *profileNVC = [[UINavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    profileNVC.viewControllers = @[[ProfileViewController new]];
    
    tabBarController.viewControllers = @[loansSearchViewController, teamSearchViewController, myNVC, updatesViewController, profileNVC];
    
    loansSearchViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Loans" image:[UIImage imageNamed:@"loan"] tag:0];
    teamSearchViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Teams" image:[UIImage imageNamed:@"team"] tag:0];
    myNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Impact" image:[UIImage imageNamed:@"impact"] tag:0];
    profileNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"me"] tag:0];
    updatesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Updates" image:[UIImage imageNamed:@"updates"] tag:0];
 
    [self setAppearance];
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Styling

- (void)setAppearance {
    UIColor *kivaColor = [[UIColor alloc] initWithRed:169/255. green:207/255. blue:141/255. alpha:1];
    UIColor *kivaColor2 = [[UIColor alloc] initWithRed:75/255. green:145/255. blue:35/255. alpha:1];
    UIColor *white = [UIColor whiteColor];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:kivaColor];
    [[UINavigationBar appearance] setTintColor:white];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:white}];
    
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:@[kivaColor, kivaColor2]];

    [[UITabBar appearance] setTintColor:kivaColor2];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[KivaClientO sharedInstance] openURL:url];
    
    return YES;
}

@end
