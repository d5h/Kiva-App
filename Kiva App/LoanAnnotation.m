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
        self.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/50/%d.jpg", loan.imageId]];
    }
    
    return self;
}

@end
