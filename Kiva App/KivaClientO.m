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

static NSString * const kConsumerKey = @"com.drrajan.codepath-kiva";
static NSString * const kConsumerSecret = @"mnFrymBhmEkAAdnCrymzwyuBnuvnHABy";
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
    [self fetchRequestTokenWithPath:@"https://api.kivaws.org/v1/oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cpkiva://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token!");
        
        NSString *urlString = [NSString stringWithFormat:@"https://www.kiva.org/oauth/authorize?oauth_token=%@", requestToken.token];
        
        NSURL *authURL = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the request token!");
        self.loginCompletion(nil, error);
    }];

}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"https://api.kivaws.org/oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got access token!");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"my/account" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            User *user = [[User alloc] initWithDictionary:responseObject];
            NSError *error;
            NSArray *users = [MTLJSONAdapter modelsOfClass:[User class] fromJSONArray:responseObject error:&error];
            if (error) {
                NSLog(@"Couldn't get User model: %@", error);
                self.loginCompletion(nil, error);
            } else {
                User *user = users[0];
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

- (void)fetchLoansWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [self GET:@"loans/newest.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

@end
