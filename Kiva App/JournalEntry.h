//
//  JournalEntry.h
//  Kiva App
//
//  Created by Dan Hipschman on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface JournalEntry : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) long identifier;
@property (copy, nonatomic, readonly) NSString *subject;
@property (copy, nonatomic, readonly) NSString *body;
@property (copy, nonatomic, readonly) NSString *author;
@property (copy, nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) long recommendationCount;
@property (nonatomic, readonly) long commentCount;

@end
