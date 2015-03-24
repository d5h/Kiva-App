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
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonView.layer.cornerRadius = 45;
    self.buttonView.layer.borderWidth = 2;
    self.buttonView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIColor *kivaColor = [[UIColor alloc] initWithRed:169/255. green:207/255. blue:141/255. alpha:1];
    UIColor *kivaColor2 = [[UIColor alloc] initWithRed:75/255. green:145/255. blue:35/255. alpha:1];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[kivaColor CGColor], (id)[kivaColor2 CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (IBAction)onLogin:(id)sender {
    [[KivaClientO sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"Welcome to %@", user.name);
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"login error: %@", error);
            // Present error view
        }
    }];
    
}

- (IBAction)onCancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
