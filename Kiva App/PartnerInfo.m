//
//  PartnerInfo.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "PartnerInfo.h"
#import "Partner.h"

@implementation PartnerInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"partners" : @"partners"
      };
}

+ (NSValueTransformer *)loansJSONTransformer
{
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Partner class]];
}

@end
