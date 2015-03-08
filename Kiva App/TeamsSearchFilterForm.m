//
//  TeamsSearchFilterForm.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "TeamsSearchFilterForm.h"

const NSString *kCategoriesAllValue = @"All Categories";

@implementation TeamsSearchFilterForm

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.category = [dictionary objectForKey:@"category"];
    }
    
    return self;
}

- (NSDictionary *)categoryField {
    return @{FXFormFieldOptions: @[
                     kCategoriesAllValue,
                     @"Alumni Groups",
                     @"Businesses",
                     @"Businesses - Internal Groups",
                     @"Clubs",
                     @"Colleges/Universities",
                     @"Common Interest",
                     @"Events",
                     @"Families",
                     @"Field Partner Fans",
                     @"Friends",
                     @"Local Area",
                     @"Memorials",
                     @"Religious Congregations",
                     @"Schools",
                     @"Sports Groups",
                     @"Youth Groups",
                     @"Other"
                     ]};
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.category) {
        [result setObject:self.category forKey:@"category"];
    }
    return result;
}

@end
