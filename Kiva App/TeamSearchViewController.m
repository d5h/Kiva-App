//
//  TeamSearchViewController.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "TeamSearchViewController.h"
#import "TeamsListViewController.h"
#import "KivaClientO.h"
#import "TeamsSearchFilterForm.h"
#import "User.h"
#import "SVProgressHUD.h"

static NSString *kMyTeams = @"My Teams";

@interface TeamSearchViewController () <UISearchBarDelegate>

@property (strong, nonatomic) TeamsListViewController *teamsListViewController;
@property (nonatomic, strong) TeamsSearchFilterForm *filterForm;
@property (nonatomic, strong) UINavigationController *filterNavigationController;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSString *searchText;


@end

@implementation TeamSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.teamsListViewController = [[TeamsListViewController alloc] init];
    [self setViewControllers:@[self.teamsListViewController]];
    
    self.filters = @{@"sort_by": @"loaned_amount"};
    [self loadTeams];


    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.teamsListViewController.navigationItem.titleView = searchBar;

    self.teamsListViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kMyTeams style:UIBarButtonItemStylePlain target:self action:@selector(onMyTeams)];
    self.teamsListViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
}

- (void)loadTeamsWithFilters:(NSDictionary *)filters {
    [SVProgressHUD show];
    [[KivaClientO sharedInstance] fetchTeamsWithParams:filters completion:^(NSArray *teams, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"TeamSearchViewController error loading teams: %@", error);
        } else {
            self.teamsListViewController.teams = teams;
        }
    }];
}

- (void)loadTeams {
    NSMutableDictionary *filters = [self.filters mutableCopy];
    if (self.searchText) {
        [filters setObject:self.searchText forKey:@"q"];
    }
    [self loadTeamsWithFilters:filters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Filtering

- (void)onFilter {
    self.filterForm = [[TeamsSearchFilterForm alloc] initWithDictionary:self.filters];
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
    [self loadTeams];
}

#pragma mark My Teams

- (void)onMyTeams {
    if ([self.teamsListViewController.navigationItem.leftBarButtonItem.title isEqualToString:kMyTeams]) {
        User *user = [User currentUser];
        if (user) {
            [SVProgressHUD show];
            [[KivaClientO sharedInstance] fetchMyTeamsWithCompletion:^(NSArray *teams, NSError *error) {
                [SVProgressHUD dismiss];
                if (error) {
                    NSLog(@"TeamSearchViewController error loading teams: %@", error);
                } else {
                    self.teamsListViewController.teams = teams;
                }
            }];
            self.teamsListViewController.navigationItem.leftBarButtonItem.title = @"All Teams";
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Requires log in" message:@"Please use the My tab to log in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        self.teamsListViewController.navigationItem.leftBarButtonItem.title = kMyTeams;
        [self loadTeams];
    }
}

#pragma mark - Seach Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    [self loadTeams];
    [searchBar resignFirstResponder];
}

@end
