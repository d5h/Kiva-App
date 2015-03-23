//
//  ProfileViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/13/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "ProfileLoanCell.h"
#import "LoginViewController.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "KivaClientO.h"
#import "Loan.h"
#import "Balance.h"
#import "LoanCell.h"
#import "LoanDetailViewController.h"
#import "AnnotationCoordinateUtility.h"
#import "KML.h"
#import "LoanAnnotation.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *balances;
@property (strong, nonatomic) ProfileHeaderView *headerView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) BOOL isMapView;
@property (nonatomic, strong) NSDictionary *countryPolygons;
// Used so we don't add country polygon overlays multiple times
@property (nonatomic, strong) NSMutableSet *countriesWithOverlays;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map"] style:UIBarButtonItemStylePlain target:self action:@selector(onMapButton)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileLoanCell" bundle:nil] forCellReuseIdentifier:@"ProfileLoanCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    
    [self loadProfile];
    
    self.mapView.delegate = self;
    self.isMapView = NO;

    [self refresh];
    
    self.countriesWithOverlays = [NSMutableSet set];
    [self loadKML];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileLoanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileLoanCell"];
    cell.loan = self.loans[indexPath.row];
    cell.balance = self.balances[indexPath.row];
    
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

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This must be called in order to work
    [scrollView shouldPositionParallaxHeader];
    
    // scrollView.parallaxHeader.progress - is progress of current scroll
//    NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
    
    // This is how you can implement appearing or disappearing of sticky view
//    [scrollView.parallaxHeader.stickyView setAlpha:scrollView.parallaxHeader.progress];
}

#pragma mark Map view methods

- (void)addAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (Loan *loan in self.loans) {
        LoanAnnotation *annotation = [[LoanAnnotation alloc] initWithLoan:loan];
        [self.mapView addAnnotation:annotation];
        if (! [self.countriesWithOverlays containsObject:loan.countryCode]
            && [self.countryPolygons objectForKey:loan.countryCode])
        {
            NSArray *polygons = [self.countryPolygons valueForKey:loan.countryCode];
            for (MKPolygon *countryPolygon in polygons) {
                [self.mapView addOverlay:countryPolygon];
                [self.countriesWithOverlays addObject:loan.countryCode];
            }
        }
    }
    
    [AnnotationCoordinateUtility mutateCoordinatesOfClashingAnnotations:self.mapView.annotations];
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
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
    
    UIImageView *imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    NSURL *imageURL = ((LoanAnnotation *)annotation).imageURL;
    [imageView setImageWithURL:imageURL];
    
    return annotationView;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if (![overlay isKindOfClass:[MKPolygon class]]) {
        return nil;
    }
    
    MKPolygon *polygon = (MKPolygon *)overlay;
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
    renderer.fillColor = [[UIColor alloc] initWithRed:127/255. green:173/255. blue:76/255. alpha:0.4];
    
    return renderer;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    LoanAnnotation *annotation = view.annotation;
    
    LoanDetailViewController *vc = [LoanDetailViewController new];
    vc.loanId = annotation.loanID;
    vc.partnerId = annotation.partnerID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)refresh {
    [[KivaClientO sharedInstance] fetchMyLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
        if (error) {
            NSLog(@"My Summary error loading my loans: %@", error);
            return;
        } else {
            self.loans = loans;
            NSMutableArray *loanIDs = [NSMutableArray array];
            for (Loan *loan in loans) {
                [loanIDs addObject:loan.identifier];
            }
            [[KivaClientO sharedInstance] fetchMyBalancesWithParams:nil withLoanIDs:(NSArray*)loanIDs completion:^(NSArray *balances, NSError *error) {
                if (error) {
                    NSLog(@"My Summary error loading balances: %@", error);
                } else {
                    self.balances = balances;
                    [self addAnnotations];
                    [self.tableView reloadData];
                }
            }];
        }
    }];
    
}

- (void)loadProfile {
    [[KivaClientO sharedInstance] fetchMyLenderWithParams:nil completion:^(Lender *lender, NSError *error) {
        if (error) {
            NSLog(@"My Summary error getting lender: %@", error);
            [self doLogin];
            return;
        } else {
            self.headerView = [ProfileHeaderView instantiateFromNibWithLender:lender];
            [self.tableView setParallaxHeaderView:self.headerView mode:VGParallaxHeaderModeFill height:150];
        }
    }];
}

- (void)doLogin {
    [self.navigationController presentViewController:[LoginViewController new] animated:NO completion:^{
        [self loadProfile];
    }];
}

- (void)onLogoutButton {
    [User logout];
}

- (void)userDidLogout {
    [self.navigationController presentViewController:[LoginViewController new] animated:NO completion:nil];
}

@end
