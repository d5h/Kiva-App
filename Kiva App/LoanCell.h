//
//  LoanCell.h
//  Kiva App
//
//  Created by David Rajan on 3/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Loan.h"

@interface LoanCell : UITableViewCell

@property (nonatomic, strong) Loan *loan;

- (void)setLoan:(Loan *)loan;

@end
