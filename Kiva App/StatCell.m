//
//  StatCell.m
//  Kiva App
//
//  Created by David Rajan on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "StatCell.h"

@implementation StatCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor greenColor];
    //self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.layer.cornerRadius = 50.0f;
}

@end
