//
//  ProfileViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/13/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "ProfileLoanCell.h"
#import "LoginViewController.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "KivaClientO.h"
#import "Loan.h"
#import "Balance.h"
#import "LoanCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *balances;
@property (strong, nonatomic) ProfileHeaderView *headerView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileLoanCell" bundle:nil] forCellReuseIdentifier:@"ProfileLoanCell"];
    
    [self loadProfile];

    [self refresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileLoanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileLoanCell"];
    cell.loan = self.loans[indexPath.row];
    cell.balance = self.balances[indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This must be called in order to work
    [scrollView shouldPositionParallaxHeader];
    
    // scrollView.parallaxHeader.progress - is progress of current scroll
    NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
    
    // This is how you can implement appearing or disappearing of sticky view
//    [scrollView.parallaxHeader.stickyView setAlpha:scrollView.parallaxHeader.progress];
}

#pragma mark - Private

- (void)refresh {
    [[KivaClientO sharedInstance] fetchMyLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
        if (error) {
            NSLog(@"My Summary error loading my loans: %@", error);
            return;
        } else {
            self.loans = loans;
            NSMutableArray *loanIDs = [NSMutableArray array];
            for (Loan *loan in loans) {
                [loanIDs addObject:loan.identifier];
            }
            [[KivaClientO sharedInstance] fetchMyBalancesWithParams:nil withLoanIDs:(NSArray*)loanIDs completion:^(NSArray *balances, NSError *error) {
                if (error) {
                    NSLog(@"My Summary error loading balances: %@", error);
                } else {
                    self.balances = balances;
                    [self.tableView reloadData];
                }
            }];
        }
    }];
    
}

- (void)loadProfile {
    [[KivaClientO sharedInstance] fetchMyLenderWithParams:nil completion:^(Lender *lender, NSError *error) {
        if (error) {
            NSLog(@"My Summary error getting lender: %@", error);
            [self doLogin];
            return;
        } else {
            self.headerView = [ProfileHeaderView instantiateFromNibWithLender:lender];
            [self.tableView setParallaxHeaderView:self.headerView mode:VGParallaxHeaderModeFill height:150];
        }
    }];
}

- (void)doLogin {
    [self.navigationController presentViewController:[LoginViewController new] animated:NO completion:^{
        [self loadProfile];
    }];
}


@end
