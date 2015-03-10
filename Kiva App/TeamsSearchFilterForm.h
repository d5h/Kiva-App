//
//  TeamsSearchFilterForm.h
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FXForms.h>

extern const NSString *kCategoriesAllValue;

@interface TeamsSearchFilterForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *sortBy;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
