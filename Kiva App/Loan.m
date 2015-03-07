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
    @"use" : @"use"
    };
}

@end
