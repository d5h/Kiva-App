//
//  LoanCell.h
//  Kiva App
//
//  Created by David Rajan on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loan.h"

@class LoanCell;

@protocol LoanCellDelegate <NSObject>

- (void)onLendNowButton:(LoanCell *)loanCell;

@end


@interface LoanCell : UITableViewCell

@property (nonatomic, strong) Loan *loan;
@property (nonatomic, weak) id <LoanCellDelegate> delegate;

- (void)setLoan:(Loan *)loan;

@end
