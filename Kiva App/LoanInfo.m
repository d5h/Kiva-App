//
//  LoanInfo.m
//  Kiva App
//
//  Created by David Rajan on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanInfo.h"
#import "Loan.h"

@implementation LoanInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"loans" : @"loans"
      };
}

+ (NSValueTransformer *)loansJSONTransformer
{
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Loan class]];
}

@end
