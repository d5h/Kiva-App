//
//  LoanDetail.h
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface LoanDetail : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *use;
@property (copy, nonatomic, readonly) NSNumber *loanAmount;
@property (copy, nonatomic, readonly) NSNumber *fundedAmount;
@property (nonatomic, readonly) int imageId;
@property (nonatomic, readonly) NSNumber *partnerId;
@property (copy, nonatomic, readonly) NSString *country;
@property (copy, nonatomic, readonly) NSString *sector;
@property (copy, nonatomic, readonly) NSString *activity;
@property (copy, nonatomic, readonly) NSString *postedDate;
@property (copy, nonatomic, readonly) NSString *plannedExpirationDate;
@property (copy, nonatomic, readonly) NSString *texts;

@end
