//
//  LoanAnnotation.h
//  Kiva App
//
//  Created by David Rajan on 3/17/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Loan.h"

@interface LoanAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title, *subtitle, *countryCode;
@property (nonatomic, strong) NSNumber *loanID;
@property (nonatomic, strong) NSNumber *partnerID;
@property (nonatomic, strong) NSURL *imageURL;

- (instancetype)initWithLoan:(Loan *)loan;

@end
