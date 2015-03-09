//
//  LoansSearchViewController.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoansSearchViewController.h"
#import "LoansViewController.h"
#import "LoanInfo.h"
#import "KivaClientO.h"
#import "LoansSearchFilterForm.h"


@interface LoansSearchViewController ()
@property (strong, nonatomic) LoansViewController *loansViewController;
@property (nonatomic, strong) LoansSearchFilterForm *filterForm;
@property (nonatomic, strong) UINavigationController *filterNavigationController;
@property (nonatomic, strong) NSDictionary *filters;

@end

@implementation LoansSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loansViewController = [[LoansViewController alloc]init];

    [self setViewControllers:@[self.loansViewController]];
    [self loadLoansWithFilters:nil];
    
    
    self.loansViewController.navigationItem.titleView = [[UISearchBar alloc] init];
    self.loansViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
    
    self.filters = @{};
}

- (void)loadLoansWithFilters:(NSDictionary *)filters {
    [[KivaClientO sharedInstance] fetchLoansWithParams:filters completion:^(NSArray *loans, NSError *error) {
        if (error) {
            NSLog(@"TeamSearchViewController error loading teams: %@", error);
        } else {
            self.loansViewController.loans = loans;
            //NSLog(@"%@", loans);
        }
    }];
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Filtering

- (void)onFilter {
    self.filterForm = [[LoansSearchFilterForm alloc] initWithDictionary:self.filters];
    FXFormViewController *formViewController = [[FXFormViewController alloc] init];
    formViewController.formController.form = self.filterForm;
    self.filterNavigationController = [[UINavigationController alloc] initWithRootViewController:formViewController];
    formViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterCancel)];
    formViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterDone)];
    [self presentViewController:self.filterNavigationController animated:YES completion:nil];
}

- (void)onFilterCancel {
    [self.filterNavigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFilterDone {
    [self.filterNavigationController dismissViewControllerAnimated:YES completion:nil];
    self.filters = [self.filterForm dictionary];
    [self loadLoansWithFilters:self.filters];

}


@end
