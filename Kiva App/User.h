//
//  User.h
//  Kiva App
//
//  Created by David Rajan on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserStats.h"

@interface User : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *firstName;
@property (copy, nonatomic, readonly) NSString *lastName;
@property (nonatomic, assign, readonly) BOOL isPublic;
@property (copy, nonatomic, readonly) NSNumber *identifier;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

@end
