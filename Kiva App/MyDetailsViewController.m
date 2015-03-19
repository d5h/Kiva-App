//
//  MyDetailsViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "MyDetailsViewController.h"
#import "Loan.h"
#import "Partner.h"
#import "StatHeader.h"
#import "StatCell.h"

@interface MyDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) NSArray *stats;
@property (strong, nonatomic) NSArray *socialPerformances;
@property (strong, nonatomic) NSArray *themes;
@property (strong, nonatomic) NSArray *sectors;
@property (strong, nonatomic) NSArray *countries;
@property (nonatomic, strong) NSArray *sectionHeaders;

@end

@implementation MyDetailsViewController

static UIColor *bgColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    bgColor = [UIColor colorWithRed:127/255.0 green:173/255.0 blue:76/255.0 alpha:1.0];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"StatCell" bundle:nil] forCellWithReuseIdentifier:@"StatCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"StatHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StatHeader"];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.stats count];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    
    switch (indexPath.section) {
        case 0:
            size = CGSizeMake(80.0, 80.0);
            break;
        case 3:
            size = CGSizeMake(30.0, 25.0);
            break;
        default:
            size = CGSizeMake(60.0, 60.0);
            break;
    }
    
    return size;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatCell" forIndexPath:indexPath];
    cell.descriptionLabel.textColor = [UIColor whiteColor];
    switch (indexPath.section) {
        case 0:
            cell.descriptionLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.0];
            cell.descriptionLabel.text = [self.stats[indexPath.section] objectAtIndex:indexPath.row];
            cell.descriptionLabel.textColor = [UIColor whiteColor];
            cell.valueLabel.text = @"";
            cell.backgroundColor = [UIColor blueColor];
            cell.layer.cornerRadius = 40.0;
            for (Partner *partner in self.partners) {
                for (NSNumber *num in partner.socialPerformanceStrengths) {
                    NSString *str = [self.socialPerformances objectAtIndex:[num integerValue]];
                    NSLog(@"str: %@", str);
                    if ([str isEqualToString:[self.stats[indexPath.section] objectAtIndex:indexPath.row]]) {
                        cell.backgroundColor = bgColor;
                        continue;
                    }
                }
            }
            break;
        case 1:
            cell.descriptionLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.0];
            cell.descriptionLabel.text = [self.stats[indexPath.section] objectAtIndex:indexPath.row];
            cell.valueLabel.text = @"";
            cell.backgroundColor = [UIColor orangeColor];
            cell.layer.cornerRadius = 30.0;
            for (Loan *loan in self.loans) {
                for (NSString *theme in loan.themes) {
                    if ([theme isEqualToString:[self.stats[indexPath.section] objectAtIndex:indexPath.row]]) {
                        cell.backgroundColor = bgColor;
                        continue;
                    }
                }
            }
            break;
        case 2:
            cell.descriptionLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.0];
            cell.descriptionLabel.text = [self.stats[indexPath.section] objectAtIndex:indexPath.row];
            cell.valueLabel.text = @"";
            cell.backgroundColor = [UIColor magentaColor];
            cell.layer.cornerRadius = 30.0;
            for (Loan *loan in self.loans) {
                if ([loan.sector isEqualToString:[self.stats[indexPath.section] objectAtIndex:indexPath.row]]) {
                    cell.backgroundColor = bgColor;
                    continue;
                }
            }
            break;
        case 3:
            cell.valueLabel.font = [UIFont fontWithName:@"Avenir Next" size:13.0];
            cell.valueLabel.text = [self.stats[indexPath.section] objectAtIndex:indexPath.row];
            cell.descriptionLabel.text = @"";
            cell.backgroundColor = [UIColor redColor];
            cell.layer.cornerRadius = 0.0;
            for (Loan *loan in self.loans) {
                if ([loan.countryCode isEqualToString:[self.stats[indexPath.section] objectAtIndex:indexPath.row]]) {
                    cell.backgroundColor = bgColor;
                    continue;
                }
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        StatHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StatHeader" forIndexPath:indexPath];
        headerView.headerLabel.text = self.sectionHeaders[indexPath.section];
        
        return headerView;
    }
    return nil;
}

#pragma mark - Private

- (void)initData {
    self.sectionHeaders = @[@"Social Performance", @"Themes", @"Sectors", @"Countries"];
    self.socialPerformances = @[@"Anti-Poverty Focus", @"Entrepreneurial Support", @"Family and Community Empowerment", @"Vulnerable Group Focus", @"Client Voice", @"Facilitation of Savings", @"Innovation"];
    self.themes = @[@"Green", @"Higher Education", @"Arab Youth", @"Kiva City LA", @"Islamic Finance", @"Youth", @"Start-Up", @"Water and Sanitation", @"Vulnerable Groups", @"Fair Trade", @"Rural Exclusion", @"Mobile Technology", @"Underfunded Areas", @"Conflict Zones", @"Job Creation", @"SME", @"Growing Businesses", @"Kiva City Detroit", @"Health", @"Disaster recovery", @"Flexible Credit Study", @"Innovative Loans"];
    self.sectors = @[@"Agriculture", @"Arts", @"Clothing", @"Construction", @"Education", @"Entertainment", @"Food", @"Health", @"Housing", @"Manufacturing", @"Personal Use", @"Retail", @"Services", @"Transportation", @"Wholesale"];
    self.countries = @[@"AF", @"AL", @"AM", @"AZ", @"BA", @"BF", @"BG", @"BI", @"BJ", @"BO", @"BR", @"BW", @"BZ", @"CD", @"CG", @"CI", @"CL", @"CM", @"CN", @"CO", @"CR", @"DO", @"EC", @"EG", @"GE", @"GH", @"GT", @"GZ", @"HN", @"HT", @"ID", @"IL", @"IN", @"IQ", @"JO", @"KE", @"KG", @"KH", @"LA", @"LB", @"LK", @"LR", @"MD", @"MG", @"ML", @"MM", @"MN", @"MR", @"MW", @"MX", @"MZ", @"NA", @"NG", @"NI", @"NP", @"PA", @"PE", @"PG", @"PH", @"PK", @"PS", @"PY", @"QS", @"RW", @"SB", @"SG", @"SL", @"SN", @"SO", @"SR", @"SV", @"TD", @"TG", @"TH", @"TJ", @"TL", @"TN", @"TR", @"TZ", @"UA", @"UG", @"US", @"VC", @"VN", @"VU", @"WS", @"XK", @"YE", @"ZA", @"ZM", @"ZW"];
  
    self.stats = [NSArray arrayWithObjects:self.socialPerformances, self.themes, self.sectors, self.countries, nil];
    [self.collectionView reloadData];
    
}

@end
