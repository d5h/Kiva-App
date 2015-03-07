//
//  LoanCell.m
//  Kiva App
//
//  Created by David Rajan on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanCell.h"
@interface LoanCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;


@end

@implementation LoanCell

- (void)awakeFromNib {
    // Initialization code
    
    self.useLabel.preferredMaxLayoutWidth = self.useLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLoan:(Loan *)loan {
    _loan = loan;
    
    self.nameLabel.text = loan.name;
    self.useLabel.text = loan.use;
}

@end
