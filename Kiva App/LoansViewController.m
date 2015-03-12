//
//  LoansViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/6/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoansViewController.h"
#import "KivaClientO.h"
#import "Loan.h"
#import "LoanCell.h"
#import "LoanDetailViewController.h"
#import "SVProgressHUD.h"
#import "BasketViewController.h"

@interface LoansViewController () <UITableViewDataSource, UITableViewDelegate, LoanCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) NSArray *loans;

@end

@implementation LoansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LoanCell" bundle:nil]forCellReuseIdentifier:@"LoanCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 450;
    

    [self.tableView reloadData];
}

- (void)setLoans:(NSArray *)loans{
    _loans = loans;
    [self.tableView reloadData];
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
    cell.delegate = self;
    cell.loan = self.loans[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LoanDetailViewController *ldvc = [[LoanDetailViewController alloc] init];
    Loan *loan = self.loans[indexPath.row];
    ldvc.loanId = loan.identifier;
    ldvc.partnerId = loan.partnerId;
    [self.navigationController pushViewController:ldvc animated:YES];
}

#pragma mark delegate methods

- (void)onLendNowButton:(LoanCell *)loanCell {
    BasketViewController *bvc = [[BasketViewController alloc]init];
    NSLog(@"going to add %@ to basketloans array", loanCell.loan);
    [bvc.basketLoans addObject:loanCell.loan];
    
}

@end
