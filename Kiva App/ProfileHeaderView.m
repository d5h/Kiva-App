//
//  ProfileHeaderView.m
//  Kiva App
//
//  Created by David Rajan on 3/14/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "User.h"
#include "UIImageView+AFNetworking.h"

@interface ProfileHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation ProfileHeaderView

+ (instancetype)instantiateFromNibWithLender:(Lender *)lender
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    
    User *user = [User currentUser];
    ProfileHeaderView *view = [views firstObject];
    view.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    [view.profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/100/%@.jpg", lender.imageID]]];
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
