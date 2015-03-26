//
//  LoanAnnotation.m
//  Kiva App
//
//  Created by David Rajan on 3/17/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanAnnotation.h"

@implementation LoanAnnotation

- (instancetype)initWithLoan:(Loan *)loan {
    self = [super init];
    if (self) {
        self.title = loan.name;
        self.subtitle = loan.use;
        self.coordinate = loan.locationCoordinate;
        self.loanID = loan.identifier;
        self.partnerID = loan.partnerId;
        self.countryCode = loan.countryCode;
        self.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/s50/%d.jpg", loan.imageId]];
    }
    
    return self;
}

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark {
    self = [super init];
    if (self) {
        self.title = placemark.country;
        self.coordinate = placemark.location.coordinate;
        self.loanID = nil;
        self.imageURL = nil;
        
    }
    return self;
}

@end
