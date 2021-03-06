//
//  UpdatesViewController.h
//  Kiva App
//
//  Created by Dan Hipschman on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalEntryCell.h"

@interface UpdatesViewController : UIViewController

@property (nonatomic, strong) NSArray *journalEntries;

- (void)setJournalEntries:(NSArray *)journalEntries;

@end
