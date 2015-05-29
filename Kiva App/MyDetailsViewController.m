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
#import "StatDetailCell.h"

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"StatDetailCell" bundle:nil] forCellWithReuseIdentifier:@"StatDetailCell"];
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
            size = CGSizeMake(32.0, 32.0);
            break;
        default:
            size = CGSizeMake(60.0, 60.0);
            break;
    }
    
    return size;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *kivaColor = [[UIColor alloc] initWithRed:169/255. green:207/255. blue:141/255. alpha:0.65];
//    UIColor *kivaColor2 = [[UIColor alloc] initWithRed:75/255. green:145/255. blue:35/255. alpha:0.95];
    
    StatDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatDetailCell" forIndexPath:indexPath];
    cell.descriptionLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.cellImageView.hidden = YES;
    cell.cellImageView.alpha = 0.4;
    cell.descriptionLabel.text = [self.stats[indexPath.section] objectAtIndex:indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            cell.descriptionLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.0];
            cell.cellImageView.hidden = NO;
            cell.cellImageView.alpha = 0.25;
            UIImage *img = [UIImage imageNamed:cell.descriptionLabel.text];
            [cell.cellImageView setImage:img];
            for (Partner *partner in self.partners) {
                for (NSNumber *num in partner.socialPerformanceStrengths) {
                    NSString *str = [self.socialPerformances objectAtIndex:[num integerValue]-1];
                    if ([str isEqualToString:[self.stats[indexPath.section] objectAtIndex:indexPath.row]]) {
                        cell.cellImageView.alpha = 0.65;
                        continue;
                    }
                }
            }
            break;
        }
        case 1:
        {
            cell.descriptionLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.0];
            cell.cellImageView.hidden = NO;
            UIImage *img = [UIImage imageNamed:@"leaf"];
            [cell.cellImageView setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            cell.cellImageView.tintColor = [UIColor lightGrayColor];
            for (Loan *loan in self.loans) {
                for (NSString *theme in loan.themes) {
                    if ([theme isEqualToString:[self.stats[indexPath.section] objectAtIndex:indexPath.row]]) {
                        cell.cellImageView.alpha = 0.9;
                        cell.cellImageView.tintColor = kivaColor;
                        continue;
                    }
                }
            }
            break;
        }
        case 2:
        {
            cell.descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:9.5];
            cell.cellImageView.hidden = NO;
            UIImage *img = [UIImage imageNamed:cell.descriptionLabel.text];
            [cell.cellImageView setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            cell.cellImageView.tintColor = [UIColor lightGrayColor];
            for (Loan *loan in self.loans) {
                if ([loan.sector isEqualToString:[self.stats[indexPath.section] objectAtIndex:indexPath.row]]) {
                    cell.cellImageView.alpha = 0.9;
                    cell.cellImageView.tintColor = kivaColor;
                    continue;
                }
            }
            break;
        }
        case 3:
        {
            cell.descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12.0];
            cell.cellImageView.hidden = NO;
            cell.cellImageView.alpha = 0.25;
            [cell.cellImageView setImage:[UIImage imageNamed:cell.descriptionLabel.text]];
            for (Loan *loan in self.loans) {
                if ([loan.countryCode isEqualToString:[self.stats[indexPath.section] objectAtIndex:indexPath.row]]) {
                    cell.cellImageView.alpha = 0.9;
                    continue;
                }
            }
            break;
        }
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
