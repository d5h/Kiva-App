//
//  MapViewController.m
//  Kiva App
//
//  Created by David Rajan on 3/16/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "MapViewController.h"
#import "SVProgressHUD.h"
#import "KivaClientO.h"
#import "KML.h"
#import "Loan.h"
#import "LoanAnnotation.h"
#import "LoanDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *loans;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self loadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapView

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

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    LoanAnnotation *annotation = view.annotation;
    
    LoanDetailViewController *vc = [LoanDetailViewController new];
    vc.loanId = annotation.loanID;
    vc.partnerId = annotation.partnerID;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private methods

- (void)loadData {
    [SVProgressHUD show];
    [[KivaClientO sharedInstance] fetchLoansWithParams:nil completion:^(NSArray *loans, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"MapViewController error loading loans: %@", error);
        } else {
            self.loans = loans;
            for (Loan *loan in loans) {
//                NSLog(@"ll=%f,%f",loan.locationCoordinate.latitude, loan.locationCoordinate.longitude);
                LoanAnnotation *annotation = [[LoanAnnotation alloc] initWithLoan:loan];
                [self.mapView addAnnotation:annotation];
            }
            [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        }
    }];
}

- (void)loadKML {
    NSString *kmlPath = [[NSBundle mainBundle] pathForResource:@"countries2" ofType:@"kml"];
    KMLRoot *root = [KMLParser parseKMLAtPath:kmlPath];
    NSArray *countries = root.placemarks;
    for (KMLPlacemark *placemark in countries) {
        NSLog(@"placemark: %@", placemark);
    }
}



@end
