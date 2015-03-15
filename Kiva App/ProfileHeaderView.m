//
//  ProfileHeaderView.m
//  Kiva App
//
//  Created by David Rajan on 3/14/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "ProfileHeaderView.h"

@implementation ProfileHeaderView

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
