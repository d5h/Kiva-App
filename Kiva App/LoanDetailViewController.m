//
//  LoanDetailViewController.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanDetailViewController.h"
#import "LoansViewController.h"
#import "KivaClientO.h"
#import "LoanDetailInfo.h"
#import "LoanDetail.h"
#import "UIImageView+AFNetworking.h"
#import "PartnerInfo.h"
#import "Partner.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"
#import <TSMessages/TSMessage.h>


@interface LoanDetailViewController ()

@property (nonatomic, strong) NSArray *loansDetails;
@property (nonatomic, strong) NSArray *partnerInfo;
@property (nonatomic, strong) NSNumber *loanIdentifier;

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
@property (weak, nonatomic) IBOutlet UIButton *lendButton;
@property (weak, nonatomic) IBOutlet UIButton *similarButton;
@property (weak, nonatomic) IBOutlet UIButton *topLendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *similarWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lendWidthConstraint;



@end

@implementation LoanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentView.alpha = 0.;
    
    [SVProgressHUD show];
    
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
    
    self.lendButton.tintColor =[[UIColor alloc] initWithRed:75/255. green:145/255. blue:35/255. alpha:1];
    
//    self.similarButton.layer.borderWidth = 1.0;
//    self.similarButton.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.topLendButton.layer.borderWidth = 1.0;
//    self.topLendButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [[KivaClientO sharedInstance] fetchLoanDetailsWithParams:nil withLoanId:self.loanId completion:^(NSArray *loansDetails, NSError *error){
        
        if (error) {
            NSLog(@"LoansDetailViewController error loading loans: %@", error);
        } else {
            LoanDetail *loandetail = loansDetails[0];
            
            self.title = loandetail.name;
            self.loanIdentifier = loandetail.identifier;

            [self.loanImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/s320/%d.jpg", loandetail.imageId]]];
            self.borrowersStoryLabel.text = loandetail.texts;
            
            [self.borrowersStoryLabel sizeToFit];
            
            self.loanUseLabel.text = [NSString stringWithFormat:@"A loan of $%ld helps %@ %@", (long)[loandetail.loanAmount integerValue], loandetail.name, loandetail.use];

            

            self.countryLabel.text = loandetail.country;
            self.sectorLabel.text = loandetail.sector;
            self.activityLabel.text = loandetail.activity;
            
            [self.countryImage setImage:[UIImage imageNamed:loandetail.countryCode]];
            [self.sectorImage setImage:[UIImage imageNamed:loandetail.sector]];
            [self.activityImage setImage:[UIImage imageNamed:@"leaf"]];


            self.loanAmountLabel.text = [NSString stringWithFormat:@"$%d/%d", [loandetail.fundedAmount intValue], [loandetail.loanAmount intValue]];
            self.percentFundedLabel.text = [NSString stringWithFormat:@"%0.0f%% funded", [loandetail.fundedAmount floatValue]/[loandetail.loanAmount floatValue] * 100];

            self.repaymentTermLabel.text = [NSString stringWithFormat:@"%d months", [loandetail.repaymentTerm intValue]];
            self.repaymentScheduleLabel.text = loandetail.repaymentSchedule;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"MMM d, y";
            
            self.listedDateLabel.text = [dateFormatter stringFromDate:loandetail.postedDate];
            self.disbursalDateLabel.text = [dateFormatter stringFromDate:loandetail.disbursalDate];
            
            if ([loandetail.currencyLossPossibility isEqualToString:@"none"]) {
                self.currencyLossPossibilityLabel.text = @"None";
            } else {
            
                self.currencyLossPossibilityLabel.text = @"Possible";
            }
            
            NSTimeInterval secondsLeft = [loandetail.plannedExpirationDate timeIntervalSinceNow];
            double daysLeft = secondsLeft/86400;
            
            if (daysLeft > 1) {
                self.daysLeftLabel.text = [NSString stringWithFormat:@"%.0f days left", daysLeft];
            } else {
                self.daysLeftLabel.text = @"0 days left";
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                self.contentView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [self.progressBar setProgress:[loandetail.fundedAmount floatValue]/[loandetail.loanAmount floatValue] animated:YES];
            }];
        }
 }];
    [[KivaClientO sharedInstance] fetchPartnerDetailsWithParams:nil withPartnerId:[NSArray arrayWithObject:[self.partnerId stringValue]] completion:^(NSArray *PartnerInfo, NSError *error){
        
        if (error) {
            NSLog(@"LoansDetailViewController error loading PartnerInfo: %@", error);
        } else {
            Partner *partner = PartnerInfo[0];
            self.partnerNameLabel.text = partner.name;
            self.partnerRiskRatingLabel.text = [NSString stringWithFormat:@"%0.2f", [partner.riskRating floatValue]];
            
            NSNumberFormatter *loansPostedFormatter = [[NSNumberFormatter alloc]init];
            loansPostedFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            [loansPostedFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

            
            self.partnerLoansPostedLabel.text = [loansPostedFormatter stringFromNumber:partner.numLoansPosted];

            
            NSNumberFormatter *totalLoansFormatter = [[NSNumberFormatter alloc]init];
            totalLoansFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            [totalLoansFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [totalLoansFormatter setMaximumFractionDigits:0];
            self.partnerTotalLoansLabel.text = [totalLoansFormatter stringFromNumber:partner.totalAmountRaised];
            
            self.partnerInterestFeesLabel.text = partner.chargesFeesAndInterest ? @"Yes" : @"No";
            self.partnerAverageLoanSizePercentLabel.text = [NSString stringWithFormat:@"%0.2f%%", [partner.averageLoanSizePercentPerCapitaIncome floatValue]];
            self.partnerCurrencyExchangeLossRateLabel.text = [NSString stringWithFormat:@"%0.2f%%", [partner.currencyExchangeLossRate floatValue]];
            self.partnerLoansAtRiskRateLabel.text = [NSString stringWithFormat:@"%0.2f%%", [partner.loansAtRiskRate floatValue]];
            
            NSTimeInterval secondsLeft = -[partner.startDate timeIntervalSinceNow];
            self.partnerTimeOnKivaLabel.text = [NSString stringWithFormat:@"%.0f months", secondsLeft/2592000];
        }
        
    }];
    
    [SVProgressHUD dismiss];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.lendWidthConstraint.constant = self.view.frame.size.width/2.;
    self.similarWidthConstraint.constant = self.view.frame.size.width/2. -1.0;
    
}
- (IBAction)onLendNowButton:(id)sender {
    WebViewController *wvc = [[WebViewController alloc]init];
    wvc.basketLoanId = self.loanIdentifier;
    
    [self.navigationController pushViewController:wvc animated:YES];
}


- (IBAction)onSimilarButton:(UIButton *)sender {
    [SVProgressHUD show];
    NSDictionary *params = @{@"loanID" : self.loanIdentifier, @"count" : @5};
    [[KivaClientO sharedInstance] fetchMySimilarLoansWithParams:params completion:^(NSArray *similarLoans, NSError *error){
        if (error) {
            NSLog(@"loanID: %ld", [self.loanIdentifier integerValue]);
            NSLog(@"LoansDetailViewController error loading Similar loans: %@", error);
            [SVProgressHUD dismiss];
            [TSMessage showNotificationInViewController:self title:@"Sorry, no similar loans found!" subtitle:nil type:TSMessageNotificationTypeWarning duration:TSMessageNotificationDurationAutomatic canBeDismissedByUser:YES];
        } else {
            LoansViewController *vc = [LoansViewController new];
            vc.title = @"Similar Loans";
            vc.loans = similarLoans;
            [self.navigationController pushViewController:vc animated:YES];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
