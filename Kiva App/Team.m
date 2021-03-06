//
//  Team.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "Team.h"

@implementation Team

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"desc": @"description",
             @"identifier": @"id",
             @"imageId": @"image.id",
             @"loanBecause": @"loan_because",
             @"loanCount": @"loan_count",
             @"loanedAmount": @"loaned_amount",
             @"memberCount": @"member_count",
             @"teamSince": @"team_since",
             };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)websiteURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)teamSinceJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
