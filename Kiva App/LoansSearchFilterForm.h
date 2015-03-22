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


@property (nonatomic, copy) NSArray *status;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSArray *region;
@property (nonatomic, copy) NSArray *country;
@property (nonatomic, copy) NSArray *sector;
@property (nonatomic, copy) NSArray *theme;
@property (nonatomic, copy) NSString *borrowerType;



@property (nonatomic, copy) NSString *sortBy;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
