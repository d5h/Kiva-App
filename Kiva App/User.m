//
//  User.m
//  Kiva App
//
//  Created by David Rajan on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"name" : @"lender_id",
      @"identifier" : @"id",
      @"firstName" : @"first_name",
      @"lastName" : @"last_name",
      @"isPublic" : @"is_public",
      };
}

static User *_currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
    
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSError *error;
            _currentUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dictionary error:&error];
            if (error) {
                NSLog(@"error deserialing current user: %@", error);
                return nil;
            }
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSError *error;
        NSDictionary *dictionary = [MTLJSONAdapter JSONDictionaryFromModel:_currentUser];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
