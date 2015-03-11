//
//  JournalEntryCell.h
//  Kiva App
//
//  Created by Dan Hipschman on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalEntry.h"

@interface JournalEntryCell : UITableViewCell

@property (nonatomic, strong) JournalEntry *journalEntry;

- (void)setJournalEntry:(JournalEntry *)journalEntry;

@end
