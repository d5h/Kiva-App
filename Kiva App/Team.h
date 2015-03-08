//
//  Team.h
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface Team : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *shortname;
@property (copy, nonatomic, readonly) NSString *category;
@property (copy, nonatomic, readonly) NSString *whereabouts;
@property (copy, nonatomic, readonly) NSString *loanBecause;
@property (copy, nonatomic, readonly) NSString *desc;  // Don't use description as it's used by MTLModel
@property (copy, nonatomic, readonly) NSURL *websiteURL;
@property (copy, nonatomic, readonly) NSDate *teamSince;
@property (copy, nonatomic, readonly) NSString *membershipType;
@property (copy, nonatomic, readonly) NSNumber *memberCount;
@property (copy, nonatomic, readonly) NSNumber *loanCount;
@property (copy, nonatomic, readonly) NSNumber *loanedAmount;
@property (nonatomic, readonly) int imageId;

@end
