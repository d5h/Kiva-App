//
//  JournalEntry.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "JournalEntry.h"

@implementation JournalEntry

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"author": @"author",
             @"body": @"body",
             @"commentCount": @"comment_count",
             @"date": @"date",
             @"identifier": @"id",
             @"recommendationCount": @"recommendation_count",
             @"subject": @"subject"};
}

// TODO: Factor this out to share with other models.
+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
