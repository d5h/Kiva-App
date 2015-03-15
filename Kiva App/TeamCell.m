//
//  TeamCell.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "TeamCell.h"
#import "UIImageView+AFNetworking.h"

@interface TeamCell ()

@property (weak, nonatomic) IBOutlet UIImageView *teamImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanAmountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanBecauseLabel;

@end

@implementation TeamCell

- (void)awakeFromNib {
    // Initialization code

    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.loanBecauseLabel.preferredMaxLayoutWidth = self.loanBecauseLabel.frame.size.width;
}

- (void)setTeam:(Team *)team {
    _team = team;
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc]init];
    currencyFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:0];
    
    NSNumberFormatter *countFormatter = [[NSNumberFormatter alloc]init];
    countFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [countFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.teamImageView.image = [UIImage imageNamed:@"kiva_team"];
    if (team.imageId != 0) {
        [self.teamImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/320/%d.jpg", team.imageId]]];
    }
    self.nameLabel.text = team.name;
    
    self.memberCountLabel.text = [NSString stringWithFormat:@"%@ members", [countFormatter stringFromNumber:team.memberCount]];
    
    self.loanAmountsLabel.text = [NSString stringWithFormat:@"%@ in %@ loans", [currencyFormatter stringFromNumber:team.loanedAmount], [countFormatter stringFromNumber:team.loanCount]];
    
    self.loanBecauseLabel.text = [NSString stringWithFormat:@"We loan because: %@", team.loanBecause];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
