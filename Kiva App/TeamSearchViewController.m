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

@interface TeamSearchViewController ()

@property (strong, nonatomic) TeamsListViewController *teamsListViewController;
@property (nonatomic, strong) TeamsSearchFilterForm *filterForm;
@property (nonatomic, strong) UINavigationController *filterNavigationController;
@property (nonatomic, strong) NSDictionary *filters;

@end

@implementation TeamSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.teamsListViewController = [[TeamsListViewController alloc] init];
    [self setViewControllers:@[self.teamsListViewController]];
    [self loadTeamsWithFilters:nil];
    
    self.teamsListViewController.navigationItem.titleView = [[UISearchBar alloc] init];
    self.teamsListViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
    
    self.filters = @{};
}

- (void)loadTeamsWithFilters:(NSDictionary *)filters {
    [[KivaClientO sharedInstance] fetchTeamsWithParams:nil completion:^(NSArray *teams, NSError *error) {
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

@end
