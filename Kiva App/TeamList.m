//
//  TeamList.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "TeamList.h"
#import "Team.h"

@implementation TeamList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (NSValueTransformer *)teamsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Team class]];
}

@end
