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
#import "LoansViewController.h"
#import "MyDetailsViewController.h"
#import "StatCell.h"
#import "User.h"
#import "Loan.h"
#import "Partner.h"
#import "SVProgressHUD.h"

@interface MySummaryViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *statNames;
@property (nonatomic, strong) NSArray *loans;
@property (nonatomic, strong) NSArray *partners;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

static UIColor *bgColor;
static NSString * const kOutstandingLoans = @"Outstanding Loans";
static NSString * const kTotalLoans = @"Total Loans";
static NSString * const kDonations = @"Donations";
static NSString * const kAmountLent = @"Total Amount Lent";
static NSString * const kInvites = @"Invites";

@implementation MySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutButton)];
    
    self.loans = nil;
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
        cell.valueLabel.text = [[self.data valueForKey:statName] stringValue];
        cell.backgroundColor = bgColor;
    }
    cell.layer.cornerRadius = 50.0f;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.data.count) {
        MyDetailsViewController *vc = [MyDetailsViewController new];
        vc.title = @"My Detailed Stats";
        vc.loans = self.loans;
        vc.partners = self.partners;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.statNames[indexPath.row] isEqualToString:kOutstandingLoans]){
        LoansViewController *vc = [LoansViewController new];
        vc.title = @"My Loans";
        vc.loans = self.loans;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Private

- (void)loadData {
    [SVProgressHUD show];
    [[KivaClientO sharedInstance] fetchUserStatsWithParams:nil completion:^(UserStats *stats, NSError *error) {
        if (error) {
            NSLog(@"My Summary error loading stats: %@", error);
            [self doLogin];
            return;
        } else {
            self.data = @{
                          kOutstandingLoans : stats.amountOutstanding,
                          kAmountLent : stats.amountLoans,
                          kTotalLoans : stats.numLoans,
                          kDonations : stats.amountDonated,
                          kInvites : stats.numInvites
                          };
            self.statNames = @[kOutstandingLoans, kTotalLoans, kDonations, kAmountLent, kInvites];

            [[KivaClientO sharedInstance] fetchMyLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
                if (error) {
                    NSLog(@"My Summary error loading my loans: %@", error);
                    [self doLogin];
                    return;
                } else {
                    self.loans = loans;
                    NSMutableArray *partners = [NSMutableArray array];
                    for (Loan *loan in loans) {
                        [partners addObject:loan.partnerId];
                    }
                    [[KivaClientO sharedInstance] fetchPartnerDetailsWithParams:nil withPartnerId:partners completion:^(NSArray *partnerInfo, NSError *error){
                        [SVProgressHUD dismiss];
                        if (error) {
                            NSLog(@"My Summary error loading partners: %@", error);
                        } else {
                            self.partners = partnerInfo;
                            [self.collectionView reloadData];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)doLogin {
    [self.navigationController presentViewController:[LoginViewController new] animated:NO completion:^{
        [self loadData];
    }];
}

- (void)onLogoutButton {
    [User logout];
}

- (void)userDidLogout {
    [self.navigationController presentViewController:[LoginViewController new] animated:NO completion:nil];
}
@end
