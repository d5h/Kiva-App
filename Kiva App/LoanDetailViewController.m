//
//  LoanDetailViewController.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanDetailViewController.h"
#import "KivaClientO.h"
#import "LoanDetailInfo.h"
#import "LoanDetail.h"
#import <PromiseKit/PromiseKit.h>
#import "UIImageView+AFNetworking.h"
#import "PartnerInfo.h"
#import "Partner.h"


@interface LoanDetailViewController ()

//@property(nonatomic, strong)LoanDetail *loanDetail;
@property (nonatomic, strong) NSArray *loansDetails;
@property (nonatomic, strong) NSArray *partnerInfo;
//@property(nonatomic, strong) NSNumber *partnerId;

@property (weak, nonatomic) IBOutlet UIView *contentView;
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
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *repaymentTermLabel;
@property (weak, nonatomic) IBOutlet UILabel *repaymentScheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *listedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *disbursalDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLossPossibilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerRiskRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerTimeOnKivaLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerLoansPostedLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerTotalLoansLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerInterestFeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerAverageLoanSizePercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerCurrencyExchangeLossRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerLoansAtRiskRateLabel;



@end

@implementation LoanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLayoutConstraint *leftConstraint =
    [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:0
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint =
    [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:0
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:0];
    [self.view addConstraint:rightConstraint];
    
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Browse" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
    
    //self.partnerId = [[NSNumber alloc]init];
    
    
    
    [[KivaClientO sharedInstance] fetchLoanDetailsWithParams:nil withLoanId:self.loanId completion:^(NSArray *loansDetails, NSError *error){
        
        if (error) {
            NSLog(@"LoansDetailViewController error loading loans: %@", error);
        } else {
            LoanDetail *loandetail = loansDetails[0];
            
            self.title = loandetail.name;

            [self.loanImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/320/%d.jpg", loandetail.imageId]]];
            self.borrowersStoryLabel.text = loandetail.texts;
            
            [self.borrowersStoryLabel sizeToFit];
            
            self.loanUseLabel.text = [NSString stringWithFormat:@"A loan of $%ld helps %@ %@", (long)[loandetail.loanAmount integerValue], loandetail.name, loandetail.use];

            

            self.countryLabel.text = loandetail.country;
            self.sectorLabel.text = loandetail.sector;
            self.activityLabel.text = loandetail.activity;


            self.loanAmountLabel.text = [NSString stringWithFormat:@"$%d/%d", [loandetail.fundedAmount intValue], [loandetail.loanAmount intValue]];
            self.percentFundedLabel.text = [NSString stringWithFormat:@"%0.0f%% funded", [loandetail.fundedAmount floatValue]/[loandetail.loanAmount floatValue] * 100];
            self.progressBar.progress = [loandetail.fundedAmount floatValue]/[loandetail.loanAmount floatValue];
            
            //self.partnerId = loandetail.partnerId;
            
            //NSLog(@"partner id is %d", [self.partnerId intValue]);

           
            
            //self.repaymentTermLabel.text = loandetail.
            
            self.repaymentTermLabel.text = [NSString stringWithFormat:@"%d months", [loandetail.repaymentTerm intValue]];
            self.repaymentScheduleLabel.text = loandetail.repaymentSchedule;
            self.listedDateLabel.text = loandetail.postedDate;
            self.disbursalDateLabel.text = loandetail.disbursalDate;
            self.currencyLossPossibilityLabel.text = loandetail.currencyLossPossibility;
 
        }
        
 }];
 
    
    
    [[KivaClientO sharedInstance] fetchPartnerDetailsWithParams:nil withPartnerId:[NSArray arrayWithObject:[self.partnerId stringValue]] completion:^(NSArray *PartnerInfo, NSError *error){
        
        if (error) {
            NSLog(@"LoansDetailViewController error loading PartnerInfo: %@", error);
        } else {
            Partner *partner = PartnerInfo[0];
            self.partnerNameLabel.text = partner.name;
            self.partnerRiskRatingLabel.text = [NSString stringWithFormat:@"%0.2f", [partner.riskRating floatValue]];
            
            self.partnerLoansPostedLabel.text = [NSString stringWithFormat:@"%d", [partner.numLoansPosted intValue]];
            self.partnerTotalLoansLabel.text = [NSString stringWithFormat:@"$%d", [partner.totalAmountRaised intValue]];
            self.partnerInterestFeesLabel.text = partner.chargesFeesAndInterest ? @"Yes" : @"No";
            self.partnerAverageLoanSizePercentLabel.text = [NSString stringWithFormat:@"%0.2f%%", [partner.averageLoanSizePercentPerCapitaIncome floatValue]];
            self.partnerCurrencyExchangeLossRateLabel.text = [NSString stringWithFormat:@"%0.2f%%", [partner.currencyExchangeLossRate floatValue]];
            self.partnerLoansAtRiskRateLabel.text = [NSString stringWithFormat:@"%0.2f%%", [partner.loansAtRiskRate floatValue]];

 
        }
        
    }];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) onBackButton {
//    [self dismissViewControllerAnimated:NO completion:nil];
//}

@end
