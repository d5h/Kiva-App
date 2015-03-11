//
//  MyDetailsViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "MyDetailsViewController.h"
#import "StatCell.h"

static NSArray * countries;


@interface MyDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.data.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    StatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatCell" forIndexPath:indexPath];
//    
//    NSString *statName = self.statNames[indexPath.row];
//    cell.descriptionLabel.text = statName;
//    cell.valueLabel.text = [NSString stringWithFormat:@"$%@", [[self.data valueForKey:statName] stringValue]];
//    
//    return cell;
    return nil;
}

#pragma mark - Private

- (void)initData {
    countries = @[@"AF", @"AL", @"AM", @"AZ", @"BA", @"BF", @"BG", @"BI", @"BJ", @"BO", @"BR", @"BW", @"BZ", @"CD", @"CG", @"CI", @"CL", @"CM", @"CN", @"CO", @"CR", @"DO", @"EC", @"EG", @"GE", @"GH", @"GT", @"GZ", @"HN", @"HT", @"ID", @"IL", @"IN", @"IQ", @"JO", @"KE", @"KG", @"KH", @"LA", @"LB", @"LK", @"LR", @"MD", @"MG", @"ML", @"MM", @"MN", @"MR", @"MW", @"MX", @"MZ", @"NA", @"NG", @"NI", @"NP", @"PA", @"PE", @"PG", @"PH", @"PK", @"PS", @"PY", @"QS", @"RW", @"SB", @"SG", @"SL", @"SN", @"SO", @"SR", @"SV", @"TD", @"TG", @"TH", @"TJ", @"TL", @"TN", @"TR", @"TZ", @"UA", @"UG", @"US", @"VC", @"VN", @"VU", @"WS", @"XK", @"YE", @"ZA", @"ZM", @"ZW"];
    
    
    
}

@end
