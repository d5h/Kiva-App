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
      @"loansAtRiskRate" : @"loans_at_risk_rate",
      @"socialPerformanceStrengths" : @"social_performance_strengths"
      
      };
}

+ (NSValueTransformer *)chargesFeesAndInterestJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}


+ (NSValueTransformer *)startDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)socialPerformanceStrengthsJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *array) {
        NSMutableArray *idArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            [idArray addObject:dict[@"id"]];
        }
        return idArray;
    } reverseBlock:^(NSArray *array) {
        return array;
    }];
}

@end
