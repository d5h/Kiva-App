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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    TeamSearchViewController *teamSearchViewController = [[TeamSearchViewController alloc] init];
    LoansSearchViewController *loansSearchViewController = [[LoansSearchViewController alloc] init];
    UIViewController *myVC;
    if ([User currentUser] == nil) {
        myVC = [LoginViewController new];
    } else {
        myVC = [MySummaryViewController new];
    }
    UINavigationController *updatesViewController = [[UINavigationController alloc] initWithRootViewController:[[UpdatesViewController alloc] init]];
    tabBarController.viewControllers = @[loansSearchViewController, teamSearchViewController, myVC, updatesViewController];
    loansSearchViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Loans" image:nil tag:0];
    teamSearchViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Teams" image:nil tag:0];
    myVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"My" image:nil tag:0];
    updatesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Updates" image:nil tag:0];
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
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
