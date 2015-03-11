//
//  LoanDetail.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanDetail.h"

@implementation LoanDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"name" : @"name",
      @"identifier" : @"id",
      @"use" : @"use",
      @"loanAmount" : @"loan_amount",
      @"fundedAmount" :@"funded_amount",
      @"imageId" : @"image.id",
      @"country" : @"location.country",
      @"sector" : @"sector",
      @"activity": @"activity",
      @"postedDate": @"posted_date",
      @"plannedExpirationDate": @"planned_expiration_date",
      @"partnerId" : @"partner_id",
      @"texts" : @"description.texts.en",
      @"repaymentTerm": @"terms.repayment_term",
      @"repaymentSchedule": @"terms.repayment_interval",
      @"disbursalDate":@"terms.disbursal_date",
      @"currencyLossPossibility" : @"loss_liability.currency_exchange",
      };
}

@end
