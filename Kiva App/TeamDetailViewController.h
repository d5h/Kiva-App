//
//  TeamDetailViewController.h
//  Kiva App
//
//  Created by Dan Hipschman on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface TeamDetailViewController : UIViewController

@property (nonatomic, strong) Team *team;

- (void)setTeam:(Team *)team;

@end
