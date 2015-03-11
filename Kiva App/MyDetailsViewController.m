//
//  MyDetailsViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "MyDetailsViewController.h"
#import "Loan.h"
#import "StatCell.h"

@interface MyDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) NSArray *stats;
@property (strong, nonatomic) NSArray * countries;

@end

@implementation MyDetailsViewController

static UIColor *bgColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    bgColor = [UIColor colorWithRed:127/255.0 green:173/255.0 blue:76/255.0 alpha:1.0];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"StatCell" bundle:nil] forCellWithReuseIdentifier:@"StatCell"];

    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.stats objectAtIndex:section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatCell" forIndexPath:indexPath];
    
    cell.valueLabel.text = self.countries[indexPath.row];
    cell.valueLabel.font = [UIFont fontWithName:@"Helvetica-Neue" size:8.0];
    cell.descriptionLabel.text = @"";
    cell.backgroundColor = [UIColor redColor];
    for (Loan *loan in self.loans) {
        if ([loan.countryCode isEqualToString:self.countries[indexPath.row]]) {
            cell.backgroundColor = bgColor;
            break;
        }
    }
    
    return cell;
}

#pragma mark - Private

- (void)initData {
    self.countries = @[@"AF", @"AL", @"AM", @"AZ", @"BA", @"BF", @"BG", @"BI", @"BJ", @"BO", @"BR", @"BW", @"BZ", @"CD", @"CG", @"CI", @"CL", @"CM", @"CN", @"CO", @"CR", @"DO", @"EC", @"EG", @"GE", @"GH", @"GT", @"GZ", @"HN", @"HT", @"ID", @"IL", @"IN", @"IQ", @"JO", @"KE", @"KG", @"KH", @"LA", @"LB", @"LK", @"LR", @"MD", @"MG", @"ML", @"MM", @"MN", @"MR", @"MW", @"MX", @"MZ", @"NA", @"NG", @"NI", @"NP", @"PA", @"PE", @"PG", @"PH", @"PK", @"PS", @"PY", @"QS", @"RW", @"SB", @"SG", @"SL", @"SN", @"SO", @"SR", @"SV", @"TD", @"TG", @"TH", @"TJ", @"TL", @"TN", @"TR", @"TZ", @"UA", @"UG", @"US", @"VC", @"VN", @"VU", @"WS", @"XK", @"YE", @"ZA", @"ZM", @"ZW"];
  
    self.stats = [NSArray arrayWithObjects:self.countries, nil];
    [self.collectionView reloadData];
    
}

@end
