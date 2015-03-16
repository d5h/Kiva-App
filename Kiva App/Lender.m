//
//  Lender.m
//  Kiva App
//
//  Created by David Rajan on 3/16/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "Lender.h"

@implementation Lender

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"name" : @"name",
      @"countryCode" : @"country_code",
      @"imageID" : @"image.id",
      @"inviteeCount" : @"invitee_count",
      @"loanBecause" : @"loan_because",
      @"loanCount" : @"loan_count",
      @"memberSince" : @"member_since",
      @"occupation" : @"occupation",
      @"occupationalInfo" : @"occupational_info",
      @"personalURL" : @"personal_url",
      @"uid" : @"uid",
      @"whereabouts" : @"whereabouts"
      };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}


+ (NSValueTransformer *)memberSinceJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
