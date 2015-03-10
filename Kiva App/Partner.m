//
//  Partner.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "Partner.h"

@implementation Partner

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"name" : @"name",
      @"identifier" : @"id",
      @"riskRating" : @"rating",
      @"startDate" : @"start_date",
      @"numLoansPosted" : @"loans_posted",
      @"totalAmountRaised" : @"total_amount_raised",
      @"imageId" : @"image.id",
      @"country" : @"countries.name",
      @"delinquencyRate" : @"delinquency_rate",
      @"defaultRate" : @"default_rate",
      @"chargesFeesAndInterest" : @"charges_fees_and_interest",
      @"currencyExchangeLossRate" :@"currency_exchange_loss_rate",
      @"averageLoanSizePercentPerCapitaIncome" :@"average_loan_size_percent_per_capita_income",
      
      };
}

@end
