//
//  LoansSearchViewController.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoansSearchViewController.h"
#import "LoansViewController.h"
#import "KivaClientO.h"
#import "LoansSearchFilterForm.h"
#import "SVProgressHUD.h"
#import "User.h"

static NSString *kMyLoans = @"My Loans";

@interface LoansSearchViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) LoansViewController *loansViewController;
@property (nonatomic, strong) LoansSearchFilterForm *filterForm;
@property (nonatomic, strong) UINavigationController *filterNavigationController;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSString *searchText;

@end

@implementation LoansSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loansViewController = [[LoansViewController alloc]init];

    [self setViewControllers:@[self.loansViewController]];
    self.filters = @{};
    [self loadLoans];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.loansViewController.navigationItem.titleView = searchBar;
    
    self.loansViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kMyLoans style:UIBarButtonItemStylePlain target:self action:@selector(onMyLoans)];
    self.loansViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];

    
}

- (void)loadLoansWithFilters:(NSDictionary *)filters {
    [SVProgressHUD show];
    [[KivaClientO sharedInstance] fetchLoansWithParams:filters completion:^(NSArray *loans, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"TeamSearchViewController error loading teams: %@", error);
        } else {
            self.loansViewController.loans = loans;
            //NSLog(@"%@", loans);
        }
    }];
}
    
- (void)loadLoans {
    NSMutableDictionary *filters = [self.filters mutableCopy];
    if (self.searchText) {
        [filters setObject:self.searchText forKey:@"q"];
    }
    [self loadLoansWithFilters:filters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Filtering

- (void)onFilter {
    self.filterForm = [[LoansSearchFilterForm alloc] initWithDictionary:self.filters];
    FXFormViewController *formViewController = [[FXFormViewController alloc] init];
    formViewController.formController.form = self.filterForm;
    self.filterNavigationController = [[UINavigationController alloc] initWithRootViewController:formViewController];
    formViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterCancel)];
    formViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterDone)];
    [self presentViewController:self.filterNavigationController animated:YES completion:nil];
}

- (void)onFilterCancel {
    [self.filterNavigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFilterDone {
    [self.filterNavigationController dismissViewControllerAnimated:YES completion:nil];
    self.filters = [self.filterForm dictionary];
    [self loadLoansWithFilters:self.filters];

}

#pragma mark My Teams

- (void)onMyLoans {
    if ([self.loansViewController.navigationItem.leftBarButtonItem.title isEqualToString:kMyLoans]) {
        User *user = [User currentUser];
        if (user) {
            [SVProgressHUD show];
            [[KivaClientO sharedInstance] fetchMyLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
                [SVProgressHUD dismiss];
                if (error) {
                    NSLog(@"LoansSearchViewController error loading loans: %@", error);
                } else {
                    self.loansViewController.loans = loans;
                }
            }];
            self.loansViewController.navigationItem.leftBarButtonItem.title = @"All Loans";
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Requires log in" message:@"Please use the My tab to log in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        self.loansViewController.navigationItem.leftBarButtonItem.title = kMyLoans;
        [self loadLoans];
    }
}

#pragma mark - Seach Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    [self loadLoans];
    [searchBar resignFirstResponder];
}

@end
