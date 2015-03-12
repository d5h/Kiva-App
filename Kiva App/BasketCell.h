//
//  BasketCell.h
//  Kiva App
//
//  Created by Syed, Afzal on 3/11/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loan.h"

@interface BasketCell : UITableViewCell
@property (nonatomic, strong) Loan *loan;

- (void)setBasket:(Loan *)loan;

@end
