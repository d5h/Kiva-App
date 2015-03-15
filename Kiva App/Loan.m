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
    @"countryCode" : @"location.country_code",
    @"sector" : @"sector",
    @"activity": @"activity",
    @"postedDate": @"posted_date",
    @"plannedExpirationDate": @"planned_expiration_date",
    @"partnerId" : @"partner_id",
    @"themes" : @"themes"
    };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}


+ (NSValueTransformer *)postedDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)plannedExpirationDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
