//
//  PartnerInfo.h
//  Kiva App
//
//  Created by Syed, Afzal on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "Partner.h"

@interface PartnerInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray *partners;


@end
