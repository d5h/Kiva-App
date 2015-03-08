//
//  LoansViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/6/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoansViewController.h"
#import "KivaClientO.h"
#import "LoanInfo.h"
#import "Loan.h"
#import "LoanCell.h"

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
    [[KivaClientO sharedInstance] fetchLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
        if (error) {
            NSLog(@"LoansViewController error loading loans: %@", error);
        } else {
            self.loans = loans;
            [self.tableView reloadData];
        }
    }];
    
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

@end
