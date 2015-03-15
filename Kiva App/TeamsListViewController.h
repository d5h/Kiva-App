//
//  TeamsListViewController.h
//  Kiva App
//
//  Created by Dan Hipschman on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniteScroll.h"
#import "PullToRefresh.h"

@interface TeamsListViewController : UIViewController

@property (nonatomic, strong) NSArray *teams;
@property (nonatomic, weak) id<InfiniteScrollDelegate> scrollDelegate;
@property (nonatomic, weak) id<PullToRefreshDelegate> pullToRefreshDelegate;

- (void)setTeams:(NSArray *)teams;

@end
