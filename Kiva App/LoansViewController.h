//
//  LoansViewController.h
//  Kiva App
//
//  Created by David Rajan on 3/6/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniteScroll.h"
#import "PullToRefresh.h"

@interface LoansViewController : UIViewController

@property (nonatomic, strong) NSArray *loans;
@property (nonatomic, weak) id<InfiniteScrollDelegate> scrollDelegate;
@property (nonatomic, weak) id<PullToRefreshDelegate> pullToRefreshDelegate;

- (void)setLoans:(NSArray *)loans;
- (void)onMapButton;

@end
