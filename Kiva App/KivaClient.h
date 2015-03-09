//
//  KivaClient.h
//  Kiva App
//
//  Created by David Rajan on 3/4/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Overcoat/Overcoat.h>

@class PMKPromise;

@interface KivaClient : OVCHTTPSessionManager

- (PMKPromise *)fetchLoansWithParameters:(NSDictionary *)parameters;
- (PMKPromise *)fetchLoanDetailsWithParameters:(NSDictionary *)parameters  withLoanId :(NSNumber*) loanId;
- (PMKPromise *)fetchTeamsWithParameters:(NSDictionary *)parameters;

+ (instancetype)sharedClient;

@end
