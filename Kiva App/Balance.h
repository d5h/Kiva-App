//
//  Balance.h
//  Kiva App
//
//  Created by David Rajan on 3/15/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Balance : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *totalAmountPurchased;
@property (copy, nonatomic, readonly) NSString *amountPurchasedLender;
@property (copy, nonatomic, readonly) NSString *amountRepaidLender;
@property (copy, nonatomic, readonly) NSString *currencyLossLender;
@property (copy, nonatomic, readonly) NSString *amountPurchasePromo;
@property (copy, nonatomic, readonly) NSString *amountRepaidPromo;
@property (copy, nonatomic, readonly) NSString *currencyLossPromo;
@property (copy, nonatomic, readonly) NSString *arrearsAmount;
@property (copy, nonatomic, readonly) NSString *status;

@end
