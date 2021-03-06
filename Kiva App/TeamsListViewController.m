//
//  TeamsListViewController.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "TeamsListViewController.h"
#import "TeamCell.h"
#import "TeamDetailViewController.h"
#import "SVPullToRefresh.h"

@interface TeamsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TeamsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TeamCell" bundle:nil] forCellReuseIdentifier:@"TeamCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self.pullToRefreshDelegate onPullToRefresh];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self.scrollDelegate scrollHitBottom];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTeams:(NSArray *)teams {
    _teams = teams;
    [self.tableView reloadData];
}

#pragma mark - Table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teams.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell"];
    cell.team = self.teams[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamDetailViewController *vc = [[TeamDetailViewController alloc] init];
    vc.team = self.teams[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
