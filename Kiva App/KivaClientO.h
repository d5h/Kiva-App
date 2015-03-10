//
//  KivaClientO.h
//  Kiva App
//
//  Created by David Rajan on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@class User;

@interface KivaClientO : BDBOAuth1RequestOperationManager

+ (KivaClientO *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)fetchUserStatsWithParams:(NSDictionary *)params completion:(void (^)(UserStats *, NSError *))completion;
- (void)fetchLoansWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion;
- (void)fetchTeamsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion;

- (void)fetchLoanDetailsWithParams:(NSDictionary *)params  withLoanId :(NSNumber*) loanId completion:(void (^)(NSArray *, NSError *))completion;

@end
