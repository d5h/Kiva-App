//
//  TeamDetailViewController.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TeamDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *teamImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLoansLabel;
@property (weak, nonatomic) IBOutlet UILabel *whereaboutsLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanBecauseLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation TeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLayoutConstraint *leftConstraint =
    [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:0
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint =
    [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:0
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:0];
    [self.view addConstraint:rightConstraint];
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc]init];
    currencyFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:0];
    
    NSNumberFormatter *countFormatter = [[NSNumberFormatter alloc]init];
    countFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [countFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.teamImageView.image = [UIImage imageNamed:@"kiva_team"];
    if (self.team.imageId != 0) {
        [self.teamImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/320/%d.jpg", self.team.imageId]]];
    }
    self.nameLabel.text = self.team.name;
    self.memberLoansLabel.text = [NSString stringWithFormat:@"%@ members with %@ in %@ loans", [countFormatter stringFromNumber:self.team.memberCount], [currencyFormatter stringFromNumber:self.team.loanedAmount], [countFormatter stringFromNumber:self.team.loanCount]];
    
    self.categoryLabel.text = [NSString stringWithFormat:@"A %@ team", self.team.category];  // Add "since <Year>"
    self.whereaboutsLabel.text = self.team.whereabouts;
    self.loanBecauseLabel.text = self.team.loanBecause;
    self.descriptionLabel.text = self.team.desc;

    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.categoryLabel.preferredMaxLayoutWidth = self.categoryLabel.frame.size.width;
    self.memberLoansLabel.preferredMaxLayoutWidth = self.memberLoansLabel.frame.size.width;
    self.loanBecauseLabel.preferredMaxLayoutWidth = self.loanBecauseLabel.frame.size.width;
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.frame.size.width;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
