//
//  Lender.h
//  Kiva App
//
//  Created by David Rajan on 3/16/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Lender : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *countryCode;
@property (copy, nonatomic, readonly) NSString *imageID;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSNumber *inviteeCount;
@property (copy, nonatomic, readonly) NSString *lenderID;
@property (copy, nonatomic, readonly) NSString *loanBecause;
@property (copy, nonatomic, readonly) NSNumber *loanCount;
@property (copy, nonatomic, readonly) NSString *memberSince;
@property (copy, nonatomic, readonly) NSString *occupation;
@property (copy, nonatomic, readonly) NSString *occupationalInfo;
@property (copy, nonatomic, readonly) NSString *personalURL;
@property (copy, nonatomic, readonly) NSString *uid;
@property (copy, nonatomic, readonly) NSString *whereabouts;

@end
