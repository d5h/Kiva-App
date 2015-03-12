//
//  LoanCell.m
//  Kiva App
//
//  Created by David Rajan on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanCell.h"
#import "UIImageView+AFNetworking.h"
@interface LoanCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loanImageView;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *loanProgressView;
@property (weak, nonatomic) IBOutlet UILabel *percentFundedLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanAmountLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end


@implementation LoanCell

- (void)awakeFromNib {
    // Initialization code
    
    self.useLabel.preferredMaxLayoutWidth = self.useLabel.frame.size.width;
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.countryLabel.preferredMaxLayoutWidth = self.countryLabel.frame.size.width;
    self.sectorLabel.preferredMaxLayoutWidth = self.sectorLabel.frame.size.width;
    self.activityLabel.preferredMaxLayoutWidth = self.activityLabel.frame.size.width;
    self.daysLeftLabel.preferredMaxLayoutWidth = self.daysLeftLabel.frame.size.width;
    self.percentFundedLabel.preferredMaxLayoutWidth = self.percentFundedLabel.frame.size.width;
    self.loanAmountLabel.preferredMaxLayoutWidth = self.loanAmountLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLoan:(Loan *)loan {
    _loan = loan;
    
    self.nameLabel.text = loan.name;
    self.useLabel.text = loan.use;
    self.countryLabel.text = loan.country;
    self.sectorLabel.text = loan.sector;
    self.activityLabel.text = loan.activity;
    
    [self.loanImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/320/%d.jpg", loan.imageId]]];

    self.loanAmountLabel.text = [NSString stringWithFormat:@"$%d/%d", [loan.fundedAmount intValue], [loan.loanAmount intValue]];
    self.percentFundedLabel.text = [NSString stringWithFormat:@"%0.0f%% funded", [loan.fundedAmount floatValue]/[loan.loanAmount floatValue] * 100];
    self.progressBar.progress = [loan.fundedAmount floatValue]/[loan.loanAmount floatValue];
    
    
}
- (IBAction)onLendNowButton:(id)sender {
    [self.delegate onLendNowButton:self];
    
}

@end
