//
//  LoansSearchFilterForm.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoansSearchFilterForm.h"



@implementation LoansSearchFilterForm

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.status = [dictionary objectForKey:@"status"];
        self.gender = [dictionary objectForKey:@"gender"];
        self.region = [dictionary objectForKey:@"region"];
        self.sortBy = [dictionary objectForKey:@"sort_by"];
    }
    
    return self;
}



- (NSDictionary *)statusField {
    return @{FXFormFieldOptions: @[
                     @"fundraising",
                     @"funded",
                     @"in_repayment",
                     @"paid",
                     @"ended_with_loss",
                     @"expired",
                     ]};
}

- (NSDictionary *)genderField {
    return @{FXFormFieldOptions: @[
                     @"male",
                     @"female",
                     ]};
}

- (NSDictionary *)regionField {
    return @{FXFormFieldOptions: @[
                     @"na",
                     @"ca",
                     @"sa",
                     @"af",
                     @"as",
                     @"me",
                     @"ee",
                     @"we",
                     @"an",
                     @"oc",
                     ]};
}

- (NSDictionary *)sortByField {
    return @{FXFormFieldOptions: @[
                     @"popularity",
                     @"loan_amount",
                     @"expiration",
                     @"newest",
                     @"oldest",
                     @"amount_remaining",
                     @"repayment_term",
                     @"random",
                     ]};
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.status) {
        [result setObject:self.status forKey:@"status"];
    }
    if (self.gender) {
        [result setObject:self.gender forKey:@"gender"];
    }
    if (self.sortBy) {
        [result setObject:self.sortBy forKey:@"sort_by"];
    }
    if (self.region) {
        [result setObject:self.region forKey:@"region"];
    }
    
    return result;
}

@end