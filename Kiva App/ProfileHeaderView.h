//
//  ProfileHeaderView.h
//  Kiva App
//
//  Created by David Rajan on 3/14/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lender.h"

@interface ProfileHeaderView : UIView

+ (instancetype)instantiateFromNibWithLender:(Lender *)lender;

@end
