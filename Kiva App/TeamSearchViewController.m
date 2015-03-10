//
//  TeamSearchViewController.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "TeamSearchViewController.h"
#import "TeamsListViewController.h"
#import "TeamList.h"
#import "KivaClientO.h"
#import "TeamsSearchFilterForm.h"

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
    [self loadTeamsWithFilters:self.filters];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.teamsListViewController.navigationItem.titleView = searchBar;
    self.teamsListViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
}

- (void)loadTeamsWithFilters:(NSDictionary *)filters {
    [[KivaClientO sharedInstance] fetchTeamsWithParams:filters completion:^(NSArray *teams, NSError *error) {
        if (error) {
            NSLog(@"TeamSearchViewController error loading teams: %@", error);
        } else {
            self.teamsListViewController.teams = teams;
        }
    }];
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
    [self loadTeamsWithFilters:self.filters];
}

#pragma mark - Seach Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    NSMutableDictionary *filters = [self.filters mutableCopy];
    [filters setObject:self.searchText forKey:@"q"];
    [self loadTeamsWithFilters:filters];
    [searchBar resignFirstResponder];
}

@end
