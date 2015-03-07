//
//  TeamCell.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "TeamCell.h"

@interface TeamCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *whereaboutsLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation TeamCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTeam:(Team *)team {
    _team = team;
    
    self.nameLabel.text = team.name;
    self.whereaboutsLabel.text = team.whereabouts;
    self.descriptionLabel.text = team.desc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
