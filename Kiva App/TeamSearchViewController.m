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
#import "KivaClient.h"

#import <PromiseKit/PromiseKit.h>

@interface TeamSearchViewController ()

@property (strong, nonatomic) TeamsListViewController *teamsListViewController;

@end

@implementation TeamSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.teamsListViewController = [[TeamsListViewController alloc] init];
    [self setViewControllers:@[self.teamsListViewController]];
    [self loadTeamsWithFilters:nil];
    
    self.teamsListViewController.navigationItem.titleView = [[UISearchBar alloc] init];
    self.teamsListViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
}

- (void)loadTeamsWithFilters:(NSDictionary *)filters {
    [[KivaClient sharedClient] fetchTeamsWithParameters:nil].then(^(TeamList *teams) {
        self.teamsListViewController.teams = teams.teams;
    });
}

- (void)onFilter {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
