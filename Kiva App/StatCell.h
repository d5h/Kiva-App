//
//  StatCell.h
//  Kiva App
//
//  Created by David Rajan on 3/9/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
