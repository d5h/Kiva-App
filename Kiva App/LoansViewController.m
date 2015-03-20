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
#import "KML.h"

@interface LoansViewController () <UITableViewDataSource, UITableViewDelegate, LoanCellDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, assign) BOOL isMapView;
@property (nonatomic, strong) NSDictionary *countryPolygons;
// Used so we don't add country polygon overlays multiple times
@property (nonatomic, strong) NSMutableSet *countriesWithOverlays;

//@property (nonatomic, strong) NSArray *loans;

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
    
    [self.tableView reloadData];
    
    self.countriesWithOverlays = [NSMutableSet set];
    [self loadKML];
}

- (void)viewDidAppear:(BOOL)animated {
    
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

#pragma mark - delegate methods

- (void)onLendNowButton:(LoanCell *)loanCell {
    WebViewController *wvc = [[WebViewController alloc]init];
    wvc.basketLoanId = loanCell.loan.identifier;
    
    [self.navigationController pushViewController:wvc animated:YES];
}

#pragma mark - Private

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
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)onMapButton {
    UIView *fromView, *toView;
    
    if (self.isMapView)
    {
        fromView = self.mapView;
        toView = self.tableView;
        self.navigationItem.rightBarButtonItem.title = @"Map";
    }
    else
    {
        fromView = self.tableView;
        toView = self.mapView;
        self.navigationItem.rightBarButtonItem.title = @"List";
    }
    
    [toView setHidden: YES];
    [self.view addSubview: toView];
    if (self.isMapView ) {
        [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"|[toView]|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(self.view, toView)]];
        [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[toView]|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(self.view, toView)]];
    }
    
    [UIView transitionFromView: fromView toView: toView duration: 1.0 options: UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews completion:^(BOOL finished) {
        [fromView removeFromSuperview];
    }];
    
    self.isMapView = !self.isMapView;
}

#pragma mark - Map / KML

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
