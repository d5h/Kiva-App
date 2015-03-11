//
//  LoansSearchFilterForm.h
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FXForms.h>



@interface LoansSearchFilterForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *sortBy;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
