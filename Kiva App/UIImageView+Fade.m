//
//  UIImageView+RottenTomatoes.m
//  Rotten Tomatoes
//
//  Created by David Rajan on 2/8/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "UIImageView+Fade.h"

@implementation UIImageView (Fade)

- (void)setImageWithURLFade:(NSURL *)url {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self setImageWithURLRequest:[NSURLRequest requestWithURL:url]
                placeholderImage:nil
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             //Fade in images if not cached.
                             //request and response are nil if cached per AFNetworking forum.
                             if (!(request == nil && response == nil)) {
                                 weakSelf.alpha = 0.0;
                                 weakSelf.image = image;
                                 [UIView animateWithDuration:0.75
                                                  animations:^{
                                                      weakSelf.alpha = 1.0;
                                                  }];
                             } else {
                                 weakSelf.image = image;
                             }
                         }
                         failure:NULL];
}

@end
