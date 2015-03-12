//
//  BasketCell.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/11/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "BasketCell.h"

@interface BasketCell()
@property (weak, nonatomic) IBOutlet UILabel *loanName;
@property (weak, nonatomic) IBOutlet UIImageView *loanCountryImage;
@property (weak, nonatomic) IBOutlet UILabel *loanCountry;
@property (weak, nonatomic) IBOutlet UIButton *lendAmountButton;


@end


@implementation BasketCell

- (void)awakeFromNib {
    // Initialization code
    self.loanName.preferredMaxLayoutWidth = self.loanName.frame.size.width;
    self.loanCountry.preferredMaxLayoutWidth = self.loanCountry.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBasket:(Loan *)loan {
    _loan = loan;
    self.loanName.text = loan.name;
    self.loanCountry.text = loan.country;
    
}


@end
