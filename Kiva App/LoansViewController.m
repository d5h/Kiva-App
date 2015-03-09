//
//  LoansViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/6/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoansViewController.h"
#import "KivaClient.h"
#import "LoanInfo.h"
#import "Loan.h"
#import "LoanCell.h"
#import "LoanDetailViewController.h"

#import <PromiseKit/PromiseKit.h>

@interface LoansViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *loans;

@end

@implementation LoansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LoanCell" bundle:nil]forCellReuseIdentifier:@"LoanCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 450;
    
    [self refresh];
}


- (void) refresh {
    [[KivaClient sharedClient] fetchLoansWithParameters:nil].then(^(LoanInfo *loanInfo) {
        self.loans = loanInfo.loans;
        [self.tableView reloadData];
        //NSLog(@"loans: %@", self.loans);
     }).catch(^(NSError *errror) {
        NSLog(@"error loading loans");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoanCell"];
    
    cell.loan = self.loans[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    LoanDetailViewController *ldvc = [[LoanDetailViewController alloc] init];
    Loan *loan = self.loans[indexPath.row];
    ldvc.loanId = loan.identifier;

    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ldvc];
    nvc.navigationBar.translucent = NO;
    
    
    
    CATransition *ldvctransition = [CATransition animation];
    ldvctransition.type = kCATransitionPush;
    ldvctransition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:ldvctransition forKey:kCATransition];
    
    [self.navigationController presentViewController:nvc animated:NO completion:nil];
}


@end
