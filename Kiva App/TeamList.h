//
//  TeamList.h
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface TeamList : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray *teams;

@end
