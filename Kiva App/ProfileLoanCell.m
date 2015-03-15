//
//  ProfileLoanCell.m
//  Kiva App
//
//  Created by David Rajan on 3/15/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "ProfileLoanCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileLoanCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLentLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loanImageView;


@end

@implementation ProfileLoanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLoan:(Loan *)loan {
    self.nameLabel.text = loan.name;
    self.useLabel.text = loan.use;
    [self.loanImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/100/%d.jpg", loan.imageId]]];
    
}

- (void)setBalance:(Balance *)balance {
    self.statusLabel.text = balance.status;
}

@end
