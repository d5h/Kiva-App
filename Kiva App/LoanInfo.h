//
//  LoanInfo.h
//  Kiva App
//
//  Created by David Rajan on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface LoanInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray *loans;

@end
