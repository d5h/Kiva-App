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

@interface LoansSearchViewController ()<UISearchBarDelegate, InfiniteScrollDelegate, PullToRefreshDelegate>
@property (strong, nonatomic) LoansViewController *loansViewController;
@property (nonatomic, strong) LoansSearchFilterForm *filterForm;
@property (nonatomic, strong) UINavigationController *filterNavigationController;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, assign) int scrollPage;

@end

@implementation LoansSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loansViewController = [[LoansViewController alloc]init];
    self.loansViewController.scrollDelegate = self;

    [self setViewControllers:@[self.loansViewController]];
    self.filters = @{};
    [self loadLoansPage1];

    
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.loansViewController.navigationItem.titleView = searchBar;
    
    self.loansViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
    self.loansViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(onMapButton)];

    
}

- (void)loadLoansWithFilters:(NSDictionary *)filters {
    [SVProgressHUD show];
    [[KivaClientO sharedInstance] fetchLoansWithParams:filters completion:^(NSArray *loans, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"TeamSearchViewController error loading teams: %@", error);
        } else {
            if (self.scrollPage == 1) {
                self.loansViewController.loans = loans;
            } else {
                NSMutableArray *allLoans = [self.loansViewController.loans mutableCopy];
                [allLoans addObjectsFromArray:loans];
                self.loansViewController.loans = allLoans;
            }
        }
    }];
}
    
- (void)loadLoans {
    NSMutableDictionary *filters = [self.filters mutableCopy];
    if (self.searchText) {
        [filters setObject:self.searchText forKey:@"q"];
    }
    if (self.scrollPage > 1) {
        [filters setObject:@(self.scrollPage) forKey:@"page"];
    }
    [self loadLoansWithFilters:filters];
}

- (void)loadLoansPage1 {
    self.scrollPage = 1;
    [self loadLoans];
}

- (void)scrollHitBottom {
    self.scrollPage++;
    [self loadLoans];
}

- (void)onPullToRefresh {
    [self loadLoans];    
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
    self.filters = @{};
    [self loadLoansPage1];
    [self.filterNavigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFilterDone {
    [self.filterNavigationController dismissViewControllerAnimated:YES completion:nil];
    self.filters = [self.filterForm dictionary];
    [self loadLoansPage1];

}

#pragma mark My Loans

- (void)onMapButton {
    [self.loansViewController onMapButton];
}

//- (void)onMyLoans {
//    if ([self.loansViewController.navigationItem.leftBarButtonItem.title isEqualToString:kMyLoans]) {
//        User *user = [User currentUser];
//        if (user) {
//            [SVProgressHUD show];
//            [[KivaClientO sharedInstance] fetchMyLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
//                [SVProgressHUD dismiss];
//                if (error) {
//                    NSLog(@"LoansSearchViewController error loading loans: %@", error);
//                } else {
//                    self.loansViewController.loans = loans;
//                }
//            }];
//            self.loansViewController.navigationItem.leftBarButtonItem.title = @"All Loans";
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Requires log in" message:@"Please use the My tab to log in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertView show];
//        }
//    } else {
//        [self loadLoansPage1];
//    }
//}

#pragma mark - Seach Bar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    [self loadLoansPage1];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    
}

@end
