//
//  JournalEntryCell.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "JournalEntryCell.h"

@interface JournalEntryCell ()

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

@implementation JournalEntryCell

- (void)awakeFromNib {
    self.subjectLabel.preferredMaxLayoutWidth = self.subjectLabel.frame.size.width;
    self.bodyLabel.preferredMaxLayoutWidth = self.bodyLabel.frame.size.width;
}

- (void)setJournalEntry:(JournalEntry *)journalEntry {
    _journalEntry = journalEntry;
    
    self.subjectLabel.text = journalEntry.subject;
    self.bodyLabel.text = journalEntry.body;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
