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
    
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.categoryLabel.preferredMaxLayoutWidth = self.categoryLabel.frame.size.width;
    self.memberLoansLabel.preferredMaxLayoutWidth = self.memberLoansLabel.frame.size.width;
    self.loanBecauseLabel.preferredMaxLayoutWidth = self.loanBecauseLabel.frame.size.width;
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.frame.size.width;
}

- (void)setTeam:(Team *)team {
    _team = team;
    
    [self.teamImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/320/%d.jpg", team.imageId]]];
    self.nameLabel.text = team.name;
    self.categoryLabel.text = [NSString stringWithFormat:@"A %@ team since %@", team.category, team.teamSince];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
