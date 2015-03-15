//
//  ProfileLoanCell.h
//  Kiva App
//
//  Created by David Rajan on 3/15/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loan.h"
#import "Balance.h"

@interface ProfileLoanCell : UITableViewCell

@property (nonatomic, strong) Loan *loan;
@property (nonatomic, strong) Balance *balance;

@end
