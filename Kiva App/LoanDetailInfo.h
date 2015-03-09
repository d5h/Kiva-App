//
//  LoanDetailInfo.h
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "LoanDetail.h"

@interface LoanDetailInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy, readonly) LoanDetail *loanDetail;

@end
