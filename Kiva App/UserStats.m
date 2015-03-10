//
//  UserStats.m
//  Kiva App
//
//  Created by David Rajan on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "UserStats.h"

@implementation UserStats

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"amountOutstanding" : @"amount_outstanding",
      @"amountLoans" : @"amount_of_loans",
      @"numLoans" : @"number_of_loans",
      @"amountDonated" : @"amount_donated",
      @"numInvites" : @"number_of_invites",
      @"amountByInvites" : @"amount_of_loans_by_invitees"
      
      };
}

@end
