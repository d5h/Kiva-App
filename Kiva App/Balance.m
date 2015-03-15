//
//  Balance.m
//  Kiva App
//
//  Created by David Rajan on 3/15/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "Balance.h"

@implementation Balance

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"identifier" : @"id",
      @"totalAmountPurchased" : @"total_amount_purchased",
      @"amountPurchasedLender" : @"amount_purchased_by_lender",
      @"amountRepaidLender" : @"amount_repaid_by_lender",
      @"currencyLossLender" : @"currency_loss_to_lender",
      @"amountPurchasePromo" : @"amount_purchase_by_promo",
      @"amountRepaidPromo" : @"amount_repaid_to_promo",
      @"currencyLossPromo" : @"currency_loss_to_promo",
      @"arrearsAmount" : @"arrears_amount",
      @"status" : @"status"
     };
}

@end
