//
//  JournalEntryCell.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "JournalEntryCell.h"
#import "DTCoreText.h"

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

    NSData *data = [journalEntry.body dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{DTUseiOS6Attributes: @(1)};
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:14]};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    NSMutableAttributedString *mutableString = [attrString mutableCopy];
    [mutableString addAttributes:attrs range:NSMakeRange(0, attrString.length)];
    
    self.bodyLabel.attributedText = mutableString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
