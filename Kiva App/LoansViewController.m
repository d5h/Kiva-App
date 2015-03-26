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
#import "LoanAnnotation.h"
#import "SVProgressHUD.h"
#import "BasketViewController.h"
#import "SVPullToRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
#import "AnnotationCoordinateUtility.h"
#import "KML.h"

@interface LoansViewController () <UITableViewDataSource, UITableViewDelegate, LoanCellDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, assign) BOOL isMapView;
@property (nonatomic, strong) NSDictionary *countryPolygons;
@property (nonatomic, strong) NSMutableArray *countryOverlays;
// Used so we don't add country polygon overlays multiple times
@property (nonatomic, strong) NSMutableSet *countriesWithOverlays;
@property (nonatomic, strong) NSMutableSet *myCountries;

@property (nonatomic, strong) NSDictionary *allCountryLoans;
@property (nonatomic, assign) NSInteger minCountryLoans;
@property (nonatomic, assign) NSInteger maxCountryLoans;

@property (nonatomic, strong) NSArray *myLoans;
@property (nonatomic, strong) NSMutableArray *myCountryAnnotations;

@end

@implementation LoansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LoanCell" bundle:nil]forCellReuseIdentifier:@"LoanCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 450;
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.pullToRefreshDelegate onPullToRefresh];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.scrollDelegate scrollHitBottom];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];

    self.mapView.delegate = self;
    self.isMapView = NO;

    self.mapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.mapView addGestureRecognizer:gesture];
    
    [self.tableView reloadData];
    
    self.countryOverlays = [NSMutableArray array];
    self.myCountries = [NSMutableSet set];
    self.countriesWithOverlays = [NSMutableSet set];
    [self loadKML];
}

- (void)setLoans:(NSArray *)loans{
    _loans = loans;
    [self addAnnotations];
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
    cell.loanImageView.image = nil;
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

#pragma mark - Map view methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSString *reuseID = @"myAnnotationView";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    //TODO: set this based on loans in portfolio
    if ([((LoanAnnotation *)annotation).countryCode isEqualToString:@"TG"]) {
        annotationView.pinColor = MKPinAnnotationColorGreen;
    } else if (((LoanAnnotation *)annotation).loanID == nil) {
        annotationView.pinColor = MKPinAnnotationColorPurple;
    } else {
        annotationView.pinColor = MKPinAnnotationColorRed;
    }
    
    UIImageView *imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    NSURL *imageURL = ((LoanAnnotation *)annotation).imageURL;
    if (imageURL != nil) {
        [imageView setImageWithURL:imageURL];
    } else {
        [imageView setImage:[UIImage imageNamed:[(LoanAnnotation *)annotation countryCode]]];
    }
    
    return annotationView;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if (![overlay isKindOfClass:[MKPolygon class]]) {
        return nil;
    }

    MKPolygon *polygon = (MKPolygon *)overlay;
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
    UIColor *green = [[UIColor alloc] initWithRed:127/255. green:173/255. blue:76/255. alpha:0.4];
    UIColor *searchColor = [[UIColor alloc] initWithRed:220/255. green:76/255. blue:170/255. alpha:0.4];

    float minGreenValue = 0.;
    float maxGreenValue = 200.;
    float a = (maxGreenValue - minGreenValue)/(self.maxCountryLoans - self.minCountryLoans);
    float b = minGreenValue - (a * self.minCountryLoans);
    
    if ([self.countriesWithOverlays containsObject:polygon.title]) {
        renderer.fillColor = searchColor;
    } else if ([self.myCountries containsObject:polygon.title]) {
        renderer.fillColor = green;
    } else {
        float val = [self.allCountryLoans[polygon.title] floatValue];
        float greenVal = maxGreenValue - (a * val + b);
        renderer.fillColor = [UIColor colorWithRed:255/255. green:greenVal/255. blue:0 alpha:0.4];
    }

    return renderer;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    LoanAnnotation *annotation = view.annotation;
    
    if (annotation.loanID == nil) {
        return;
    }
    
    LoanDetailViewController *vc = [LoanDetailViewController new];
    vc.loanId = annotation.loanID;
    vc.partnerId = annotation.partnerID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate methods

- (void)onLendNowButton:(LoanCell *)loanCell {
    WebViewController *wvc = [[WebViewController alloc]init];
    wvc.basketLoanId = loanCell.loan.identifier;
    
    [self.navigationController pushViewController:wvc animated:YES];
}

#pragma mark - Private

- (void)onTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint tappedPoint = [gestureRecognizer locationInView:self.mapView];
        UIView *view = [self.mapView hitTest:tappedPoint withEvent:nil];
        
        if ([view isKindOfClass:[MKAnnotationView class]]) {
            return;
        }
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[gestureRecognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
        
        CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:pinLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks && placemarks.count > 0) {
                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                LoanAnnotation *anAddress = [[LoanAnnotation alloc] initWithPlacemark:topResult];
                NSString *numLoans = (self.allCountryLoans[topResult.ISOcountryCode] == nil) ? @"0" : [self.allCountryLoans[topResult.ISOcountryCode] stringValue];
                anAddress.subtitle = [NSString stringWithFormat:@"%@ loans", numLoans];
                anAddress.countryCode = topResult.ISOcountryCode;
                
                [self.mapView addAnnotation:anAddress];
                [self.mapView selectAnnotation:anAddress animated:YES];
            }
        }];
    }
}

- (void)addAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.countriesWithOverlays removeAllObjects];
    for (Loan *loan in self.loans) {
        LoanAnnotation *annotation = [[LoanAnnotation alloc] initWithLoan:loan];
        [self.mapView addAnnotation:annotation];
        if (! [self.countriesWithOverlays containsObject:loan.countryCode]
            && [self.countryPolygons objectForKey:loan.countryCode])
        {
            NSArray *polygons = [self.countryPolygons valueForKey:loan.countryCode];
            for (MKPolygon *countryPolygon in polygons) {
                countryPolygon.title = loan.countryCode;
                [self.countriesWithOverlays addObject:loan.countryCode];
                [self.mapView addOverlay:countryPolygon];
            }
        }
    }
    [self loadCountryLoans];
    
    [AnnotationCoordinateUtility mutateCoordinatesOfClashingAnnotations:self.mapView.annotations];
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
    for (LoanAnnotation *annotation in self.myCountryAnnotations) {
        [self.mapView addAnnotation:annotation];
    }
}

- (void)onMapButton {
    UIView *fromView, *toView;
    
    if (self.isMapView)
    {
        fromView = self.mapView;
        toView = self.tableView;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"map"];
    }
    else
    {
        fromView = self.tableView;
        toView = self.mapView;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"list"];
    }
    
    [UIView transitionFromView: fromView toView: toView duration: 0.5 options: UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews completion:^(BOOL finished) {
    }];
    
    self.isMapView = !self.isMapView;
}

#pragma mark - Map / KML

- (void)loadCountryLoans {
//    Hardcoding total outstanding loans per country to show highlight functionality since this is not easily available via Kiva API.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.allCountryLoans = @{
                                 @"DO" : @4,
                                 @"MX" : @9,
                                 @"US" : @14,
                                 @"CR" : @16,
                                 @"SV" : @475,
                                 @"GT" : @58,
                                 @"HN" : @14,
                                 @"NI" : @86,
                                 @"BO" : @91,
                                 @"CO" : @175,
                                 @"EC" : @18,
                                 @"PY" : @26,
                                 @"PE" : @40,
                                 @"SR" : @4,
                                 @"BI" : @4,
                                 @"GH" : @14,
                                 @"KE" : @661,
                                 @"ML" : @7,
                                 @"MZ" : @25,
                                 @"RW" : @49,
                                 @"SN" : @31,
                                 @"SL" : @23,
                                 @"TZ" : @13,
                                 @"TG" : @3,
                                 @"UG" : @92,
                                 @"AL" : @21,
                                 @"AM" : @207,
                                 @"GE" : @41,
                                 @"JO" : @16,
                                 @"LB" : @48,
                                 @"PS" : @14,
                                 @"YE" : @12,
                                 @"AZ" : @60,
                                 @"KH" : @102,
                                 @"ID" : @47,
                                 @"KG" : @81,
                                 @"MM" : @1,
                                 @"PK" : @159,
                                 @"PH" : @288,
                                 @"TJ" : @307,
                                 @"VN" : @69,
                                 @"WS" : @41,
                                 @"TL" : @6
                                 };
        
        self.minCountryLoans = [[[self.allCountryLoans allValues] valueForKeyPath:@"@min.intValue"] integerValue];
        self.maxCountryLoans = [[[self.allCountryLoans allValues] valueForKeyPath:@"@max.intValue"] integerValue];
//        NSLog(@"min: %ld, max: %ld", self.minCountryLoans, self.maxCountryLoans);
        
        [[KivaClientO sharedInstance] fetchMyLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
            if (error) {
                NSLog(@"LoansViewController error loading my loans: %@", error);
                return;
            } else {
                self.myLoans = loans;
                self.myCountryAnnotations = [NSMutableArray array];
                for (Loan *loan in self.myLoans) {
                    [self.myCountries addObject:loan.countryCode];
                
                    LoanAnnotation *annotation = [[LoanAnnotation alloc] initWithLoan:loan];
                    [self.myCountryAnnotations addObject:annotation];
                    [self.mapView addAnnotation:annotation];
                    if (! [self.countriesWithOverlays containsObject:loan.countryCode]
                        && [self.countryPolygons objectForKey:loan.countryCode])
                    {
                        NSArray *polygons = [self.countryPolygons valueForKey:loan.countryCode];
                        for (MKPolygon *countryPolygon in polygons) {
                            countryPolygon.title = loan.countryCode;
//                            [self.countriesWithOverlays addObject:loan.countryCode];
                            [self.mapView addOverlay:countryPolygon];
                        }
                    }
                }
                
//                NSMutableArray *partners = [NSMutableArray array];
//                for (Loan *loan in loans) {
//                    [partners addObject:loan.partnerId];
//                }
//                [[KivaClientO sharedInstance] fetchPartnerDetailsWithParams:nil withPartnerId:partners completion:^(NSArray *partnerInfo, NSError *error){
//                    [SVProgressHUD dismiss];
//                    if (error) {
//                        NSLog(@"My Summary error loading partners: %@", error);
//                    } else {
//                        self.partners = partnerInfo;
//                        [self.collectionView reloadData];
//                    }
//                }];
            }
        }];
        
    });
    
    for (NSString *countryCode in self.allCountryLoans) {
        if ([self.countriesWithOverlays containsObject:countryCode]) {
            continue;
        }
        NSArray *polygons = [self.countryPolygons valueForKey:countryCode];
        for (MKPolygon *countryPolygon in polygons) {
            countryPolygon.title = countryCode;
            [self.mapView addOverlay:countryPolygon];
        }
    }
    
}

- (void)loadKML {
    NSString *kmlPath = [[NSBundle mainBundle] pathForResource:@"countries2" ofType:@"kml"];
    KMLRoot *root = [KMLParser parseKMLAtPath:kmlPath];
    NSArray *countries = root.placemarks;
    NSMutableDictionary *countryPolygons = [NSMutableDictionary dictionary];
    for (KMLPlacemark *placemark in countries) {
        NSString *countryCode = [placemark.descriptionValue substringWithRange:NSMakeRange(9, 2)];
        NSMutableArray *polygons = [NSMutableArray array];

        KMLMultiGeometry *geometry = (KMLMultiGeometry *)placemark.geometry;
        for (KMLAbstractGeometry *g in geometry.geometries) {
            if ([g isKindOfClass:[KMLPolygon class]]) {
                KMLPolygon *kmlPolygon = (KMLPolygon *)g;
                NSArray *coordinates = kmlPolygon.outerBoundaryIs.coordinates;
                CLLocationCoordinate2D *mapPoints = malloc([coordinates count] * sizeof(CLLocationCoordinate2D));
                int i = 0;
                for (KMLCoordinate *c in coordinates) {
                    mapPoints[i].latitude = c.latitude;
                    mapPoints[i++].longitude = c.longitude;
                }
                MKPolygon *polygon = [MKPolygon polygonWithCoordinates:mapPoints count:[coordinates count]];
                free(mapPoints);
                [polygons addObject:polygon];
            }
        }
        
        [countryPolygons setValue:polygons forKey:countryCode];
    }
    self.countryPolygons = countryPolygons;
}

@end
