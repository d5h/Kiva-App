//
//  LoginViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoginViewController.h"
#import "MySummaryViewController.h"
#import "KivaClientO.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)onLogin:(id)sender {
    [[KivaClientO sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"Welcome to %@", user.name);
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MySummaryViewController alloc] init]] animated:YES completion:nil];
        } else {
            NSLog(@"login error: %@", error);
            // Present error view
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
