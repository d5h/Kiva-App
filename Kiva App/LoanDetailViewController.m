//
//  LoanDetailViewController.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanDetailViewController.h"
#import "KivaClient.h"
#import "LoanDetailInfo.h"
#import "LoanDetail.h"
#import <PromiseKit/PromiseKit.h>


@interface LoanDetailViewController ()

@property(nonatomic, strong)LoanDetail *loanDetail;

@property (weak, nonatomic) IBOutlet UIImageView *loanImage;
@property (weak, nonatomic) IBOutlet UILabel *loanAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentFundedLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sectorImage;
@property (weak, nonatomic) IBOutlet UILabel *sectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *loanUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowersStoryLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation LoanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[KivaClient sharedClient] fetchLoansWithParameters:nil].then(^(LoanInfo *loanInfo) {
//        self.loans = loanInfo.loans;
//        [self.tableView reloadData];
//        //NSLog(@"loans: %@", self.loans);
//    }).catch(^(NSError *errror) {
//        NSLog(@"error loading loans");
//    });

//    - (PMKPromise *)fetchLoanDetailsWithParameters:(NSDictionary *)parameters : (NSNumber*) loanId {
//        //    NSString *path = @"loans/newest.json";
//        NSString *path = [NSString stringWithFormat:@"loans/%d.json", [loanId intValue]];
//        
//        return [self GET:path parameters:parameters].then(^(OVCResponse *response) {
//            // NSLog(@"response %@", response.result);
//            return response.result;
//        });
//        
//    }

    
    [[KivaClient sharedClient] fetchLoanDetailsWithParameters:nil withLoanId:self.loanId].then(^(LoanDetailInfo *loanDetailInfo){
        self.loanDetail = loanDetailInfo.loanDetail;
        
    }).catch(^(NSError *error){
        NSLog(@"error loading loan details");
        
    });
    self.borrowersStoryLabel.text = self.loanDetail.texts;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
