//
//  UserStats.h
//  Kiva App
//
//  Created by David Rajan on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel.h"

@interface UserStats : MTLModel  <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *amountOutstanding;
@property (nonatomic, copy, readonly) NSNumber *amountLoans;
@property (nonatomic, copy, readonly) NSNumber *numLoans;
@property (nonatomic, copy, readonly) NSNumber *amountDonated;
@property (nonatomic, copy, readonly) NSNumber *numInvites;
@property (nonatomic, copy, readonly) NSNumber *amountByInvites;

@end
