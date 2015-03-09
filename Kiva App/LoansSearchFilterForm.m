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

- (NSDictionary *)dictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.status) {
        [result setObject:self.status forKey:@"status"];
    }
    return result;
}

@end