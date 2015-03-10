//
//  KivaClientO.m
//  Kiva App
//
//  Created by David Rajan on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "KivaClientO.h"
#import "Loan.h"
#import "Team.h"
#import "LoanDetail.h"
#import "PartnerInfo.h"
#import "Partner.h"

static NSString * const kConsumerKey = @"com.drrajan.cp-kiva-app";
static NSString * const kConsumerSecret = @"tptzHtsswtGmqsltikFDwxAxGjnmkxCm";
static NSString * const kBaseURL = @"https://api.kivaws.org/v1/";

@interface KivaClientO ()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation KivaClientO

+ (KivaClientO *)sharedInstance {
    static KivaClientO *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[KivaClientO alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL] consumerKey:kConsumerKey consumerSecret:kConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *, NSError *))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"https://api.kivaws.org/oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cpkiva://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token!");
        
        NSString *urlString = [NSString stringWithFormat:@"https://www.kiva.org/oauth/authorize?client_id=%@&response_type=code&scope=access,user_balance,user_email,user_expected_repayments,user_anon_lender_data,user_anon_lender_loans,user_loan_balances,user_stats,user_anon_lender_teams&oauth_callback=cpkiva%%3A%%2F%%2Foauth&oauth_token=%@", kConsumerKey, requestToken.token];
        
        NSURL *authURL = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the request token!");
        self.loginCompletion(nil, error);
    }];

}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"https://api.kivaws.org/oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got access token: %@ secret: %@!", accessToken.token, accessToken.secret);
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"my/account.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response: %@", responseObject);
            NSError *error;
            User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject[@"user_account"] error:&error];
            if (error) {
                NSLog(@"Couldn't get User model: %@", error);
                self.loginCompletion(nil, error);
            } else {
                [User setCurrentUser:user];
                NSLog(@"current user %@", user.name);
                self.loginCompletion(user, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"failed to get access token!");
        self.loginCompletion(nil, error);
    }];

}

- (void)fetchUserStatsWithParams:(NSDictionary *)params completion:(void (^)(UserStats *, NSError *))completion {
    [self GET:@"my/stats.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        UserStats *stats = [MTLJSONAdapter modelOfClass:[UserStats class] fromJSONDictionary:responseObject error:&error];
        if (error) {
            NSLog(@"Error deserializing stats: %@", error);
            completion(nil, error);
        } else {
            completion(stats, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)fetchLoansWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [self GET:@"loans/search.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSArray *loans = [MTLJSONAdapter modelsOfClass:[Loan class] fromJSONArray:responseObject[@"loans"] error:&error];
        if (error) {
            NSLog(@"Error deserializing loans: %@", error);
            completion(nil, error);
        } else {
            completion(loans, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];

}

- (void)fetchTeamsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [self GET:@"teams/search.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSArray *loans = [MTLJSONAdapter modelsOfClass:[Team class] fromJSONArray:responseObject[@"teams"] error:&error];
        if (error) {
            NSLog(@"Error deserializing teams: %@", error);
            completion(nil, error);
        } else {
            completion(loans, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)fetchLoanDetailsWithParams:(NSDictionary *)params  withLoanId :(NSNumber*) loanId completion:(void (^)(NSArray *, NSError *))completion {
    
    NSString *path = [NSString stringWithFormat:@"loans/%d.json", [loanId intValue]];
    [self GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSArray *loans = [MTLJSONAdapter modelsOfClass:[LoanDetail class] fromJSONArray:responseObject[@"loans"] error:&error];
        if (error) {
            NSLog(@"Error deserializing loan details: %@", error);
            completion(nil, error);
        } else {
            completion(loans, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)fetchPartnerDetailsWithParams:(NSDictionary *)params  withPartnerId :(NSNumber*) partnerId completion:(void (^)(NSArray *, NSError *))completion {
    NSString *path = [NSString stringWithFormat:@"partners/%d.json", [partnerId intValue]];
    [self GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSArray *partners = [MTLJSONAdapter modelsOfClass:[PartnerInfo class] fromJSONArray:responseObject[@"partners"] error:&error];
        if (error) {
            NSLog(@"Error deserializing loan details: %@", error);
            completion(nil, error);
        } else {
            completion(partners, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
}

//NSString *path = [NSString stringWithFormat:@"loans/%d.json", [loanId intValue]];
//NSLog(@"Going to fetch path %@", path);
//
//return [self GET:path parameters:parameters].then(^(OVCResponse *response) {
//    NSLog(@"response %@", response.result);
//    return response.result;
//});

@end
