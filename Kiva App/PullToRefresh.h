//
//  PullToRefresh.h
//  Kiva App
//
//  Created by Syed, Afzal on 3/14/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#ifndef Kiva_App_PullToRefresh_h
#define Kiva_App_PullToRefresh_h

@protocol PullToRefreshDelegate <NSObject>

- (void)onPullToRefresh;

@end


#endif

