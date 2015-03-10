//
//  LoanDetailViewController.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoanDetailViewController.h"
#import "KivaClient.h"
#import "KivaClientO.h"
#import "LoanDetailInfo.h"
#import "LoanDetail.h"
#import <PromiseKit/PromiseKit.h>
#import "UIImageView+AFNetworking.h"


@interface LoanDetailViewController ()

//@property(nonatomic, strong)LoanDetail *loanDetail;
@property (nonatomic, strong) NSArray *loansDetails;

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

@end

@implementation LoanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Browse" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
    
    [[KivaClientO sharedInstance] fetchLoanDetailsWithParams:nil withLoanId:self.loanId completion:^(NSArray *loansDetails, NSError *error){
        
        if (error) {
            NSLog(@"LoansDetailViewController error loading loans: %@", error);
        } else {
            LoanDetail *loandetail = loansDetails[0];
            
            self.title = loandetail.name;

            [self.loanImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kiva.org/img/320/%d.jpg", loandetail.imageId]]];
            self.borrowersStoryLabel.text = loandetail.texts;
            self.loanUseLabel.text = [NSString stringWithFormat:@"A loan of $%ld helps %@ %@", (long)[loandetail.loanAmount integerValue], loandetail.name, loandetail.use];

            

            self.countryLabel.text = loandetail.country;
            self.sectorLabel.text = loandetail.sector;
            self.activityLabel.text = loandetail.activity;


            self.loanAmountLabel.text = [NSString stringWithFormat:@"$%d/%d", [loandetail.fundedAmount intValue], [loandetail.loanAmount intValue]];
            self.percentFundedLabel.text = [NSString stringWithFormat:@"%0.0f%% funded", [loandetail.fundedAmount floatValue]/[loandetail.loanAmount floatValue] * 100];
            self.progressBar.progress = [loandetail.fundedAmount floatValue]/[loandetail.loanAmount floatValue];

            
 
        }
        
 }];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onBackButton {
    CATransition *tdvctransition = [CATransition animation];
    tdvctransition.type = kCATransitionPush;
    tdvctransition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:tdvctransition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
