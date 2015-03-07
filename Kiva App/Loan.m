//
//  Loan.m
//  Kiva App
//
//  Created by David Rajan on 3/4/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "Loan.h"

@implementation Loan

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
  @{
    @"name" : @"name",
    @"identifier" : @"id",
    @"use" : @"use",
    @"loanAmount" : @"loan_amount",
    @"fundedAmount" :@"funded_amount",
    @"imageId" : @"image.id",
    @"country" : @"location.country",
    @"sector" : @"sector",
    @"activity": @"activity",
    @"postedDate": @"posted_date",
    @"plannedExpirationDate": @"planned_expiration_date",
    @"partnerId" : @"partner_id",
    };
}

@end
