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
        self.sortBy = [dictionary objectForKey:@"sort_by"];
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

- (NSDictionary *)sortByField {
    return @{FXFormFieldOptions: @[
                     @"newest",
                     @"oldest",
                     @"member_count",
                     @"loan_count",
                     @"loaned_amount",
                     @"query_relevance"
                     ]};
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.category) {
        [result setObject:self.category forKey:@"category"];
    }
    if (self.sortBy) {
        [result setObject:self.sortBy forKey:@"sort_by"];
    }
    return result;
}

@end
