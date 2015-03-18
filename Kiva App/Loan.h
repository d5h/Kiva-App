//
//  Loan.h
//  Kiva App
//
//  Created by David Rajan on 3/4/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import <MapKit/MapKit.h>

@interface Loan : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *use;
@property (copy, nonatomic, readonly) NSNumber *loanAmount;
@property (copy, nonatomic, readonly) NSNumber *fundedAmount;
@property (nonatomic, readonly) int imageId;
@property (nonatomic, readonly) NSNumber *partnerId;
@property (copy, nonatomic, readonly) NSString *country;
@property (copy, nonatomic, readonly) NSString *countryCode;
@property (copy, nonatomic, readonly) NSString *sector;
@property (copy, nonatomic, readonly) NSString *activity;
@property (copy, nonatomic, readonly) NSDate *postedDate;
@property (copy, nonatomic, readonly) NSDate *plannedExpirationDate;
@property (copy, nonatomic, readonly) NSArray *themes;
@property(nonatomic, assign) CLLocationCoordinate2D locationCoordinate;


@end
