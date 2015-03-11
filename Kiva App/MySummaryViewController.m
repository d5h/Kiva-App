//
//  MySummaryViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "MySummaryViewController.h"
#import "KivaClientO.h"
#import "LoginViewController.h"
#import "MyDetailsViewController.h"
#import "StatCell.h"
#import "User.h"
#import "SVProgressHUD.h"

@interface MySummaryViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *statNames;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

static UIColor *bgColor;

@implementation MySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"StatCell" bundle:nil] forCellWithReuseIdentifier:@"StatCell"];
    
    self.user = [User currentUser];
    
    bgColor = [UIColor colorWithRed:127/255.0 green:173/255.0 blue:76/255.0 alpha:1.0];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    StatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatCell" forIndexPath:indexPath];
    if (indexPath.row == self.data.count) {
        cell.valueLabel.text = @"More >";
        cell.descriptionLabel.text = @"See more!";
        cell.backgroundColor = [UIColor redColor];
        
    } else {
        NSString *statName = self.statNames[indexPath.row];
        cell.descriptionLabel.text = statName;
        cell.valueLabel.text = [NSString stringWithFormat:@"$%@", [[self.data valueForKey:statName] stringValue]];
        cell.backgroundColor = bgColor;
    }
    cell.layer.cornerRadius = 50.0f;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.data.count) {
        [[KivaClientO sharedInstance] fetchMyLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
            if (error) {
                NSLog(@"My Summary error loading my loans: %@", error);
            } else {
                MyDetailsViewController *vc = [MyDetailsViewController new];
                vc.loans = loans;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];

    }
}

#pragma mark - Private

- (void)loadData {
    [SVProgressHUD show];
    [[KivaClientO sharedInstance] fetchUserStatsWithParams:nil completion:^(UserStats *stats, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [self.navigationController presentViewController:[LoginViewController new] animated:NO completion:nil];
            NSLog(@"My Summary error loading stats: %@", error);
        } else {
            self.data = @{
                          @"Outstanding Loans" : stats.amountOutstanding,
                          @"Total Amount Lent" : stats.amountLoans,
                          @"Loans" : stats.numLoans,
                          @"Donations" : stats.amountDonated,
                          @"Invites" : stats.numInvites
                          };
            self.statNames = [self.data allKeys];
            [self.collectionView reloadData];
        }
    }];
    
    
}
@end
