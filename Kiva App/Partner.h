//
//  Partner.h
//  Kiva App
//
//  Created by Syed, Afzal on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface Partner : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSNumber *riskRating;
@property (copy, nonatomic, readonly) NSString *startDate;
@property (copy, nonatomic, readonly) NSNumber *numLoansPosted;
@property (copy, nonatomic, readonly) NSNumber *totalAmountRaised;
@property (nonatomic, readonly) int imageId;
@property (copy, nonatomic, readonly) NSString *country;
@property (copy, nonatomic, readonly) NSNumber *delinquencyRate;
@property (copy, nonatomic, readonly) NSNumber *defaultRate;
@property (copy, nonatomic, readonly) NSString *chargesFeesAndInterest;
@property (copy, nonatomic, readonly) NSNumber *averageLoanSizePercentPerCapitaIncome;
@property (nonatomic, readonly) NSNumber *currencyExchangeLossRate;
@property (nonatomic, readonly) NSNumber *loansAtRiskRate;

@end
