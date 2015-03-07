//
//  KivaClient.m
//  Kiva App
//
//  Created by David Rajan on 3/4/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "KivaClient.h"
#import "LoanInfo.h"
#import "TeamList.h"

#import <Overcoat/PromiseKit+Overcoat.h>

static NSString * const kBaseURL = @"http://api.kivaws.org/v1/";

@implementation KivaClient

#pragma mark - Lifecycle

static KivaClient *_sharedClient = nil;

+ (instancetype)sharedClient {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedClient == nil) {
            _sharedClient = [[[self class] alloc] init];// initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return _sharedClient;
}


- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kBaseURL]];

    
    return self;
}

#pragma mark - Requests

- (PMKPromise *)fetchLoansWithParameters:(NSDictionary *)parameters {
    NSString *path = @"loans/newest.json";
    
    return [self GET:path parameters:parameters].then(^(OVCResponse *response) {
       // NSLog(@"response %@", response.result);
        return response.result;
    });
}

- (PMKPromise *)fetchTeamsWithParameters:(NSDictionary *)parameters {
    NSString *path = @"teams/search.json";
    
    return [self GET:path parameters:parameters].then(^(OVCResponse *response) {
        return response.result;
    });
}


#pragma mark - OVCHTTPSessionManager

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"loans/*": [LoanInfo class],
             @"teams/*": [TeamList class]
             };
}

@end
