//
//  MySummaryViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "MySummaryViewController.h"
#import "KivaClientO.h"
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

@implementation MySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"StatCell" bundle:nil] forCellWithReuseIdentifier:@"StatCell"];
    
    self.user = [User currentUser];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatCell" forIndexPath:indexPath];
    
    NSString *statName = self.statNames[indexPath.row];
    cell.descriptionLabel.text = statName;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%@", [[self.data valueForKey:statName] stringValue]];
    
    return cell;
}

#pragma mark - Private

- (void)loadData {
    [SVProgressHUD show];
    [[KivaClientO sharedInstance] fetchUserStatsWithParams:nil completion:^(UserStats *stats, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"LoansViewController error loading loans: %@", error);
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
