//
//  WebViewController.m
//  Kiva App
//
//  Created by Afzal Syed on 3/17/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "WebViewController.h"
#import "UIWebView+AFNetworking.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSMutableSet *loadIdsSet;
@property (nonatomic, strong) NSURLRequest *urlRequest;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadIdsSet = [NSMutableSet set];
    
    // Remember basket for 5 minutes
    // Make the default loan amount to be $25
    NSDate *lastUpdateTime = [self getFromDefaults:@"lastUpdateTime"];
    if (lastUpdateTime && -[lastUpdateTime timeIntervalSinceNow] < 300) {
        if ([self getFromDefaults:@"loadIdsSet"] != nil) {
                self.loadIdsSet = [self getFromDefaults:@"loadIdsSet"];
            }
        
    }
    
    [self.loadIdsSet addObject:self.basketLoanId];
    
    [self saveToDefault:self.loadIdsSet forKey:@"loadIdsSet"];
    [self saveToDefault:[NSDate date] forKey:@"lastUpdateTime"];
    

    NSMutableString *loanString = [NSMutableString stringWithString:@"loans=["];
    float donationAmount = 3.75 * self.loadIdsSet.count;

    for (NSNumber *loadId in self.loadIdsSet) {
        NSString *stringToappend = [NSString stringWithFormat:@"{\"id\":%ld,\"amount\":25},", [loadId integerValue]];
        [loanString appendString:stringToappend];
        
    }
    [loanString deleteCharactersInRange:NSMakeRange([loanString length]-1, 1)];
    [loanString appendString:[NSString stringWithFormat:@"]&app_id=com.drrajan.cp-kiva-app&donation=%0.2f", donationAmount]];
    
    NSData* data = [loanString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kiva.org/basket/set"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private methods

-(void) saveToDefault:(id) object forKey:(NSString*) forKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [defaults setObject:data forKey:forKey];
    [defaults synchronize];
}

-(id) getFromDefaults:(NSString*) forKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSData *data = [defaults objectForKey:forKey];
    if (data != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return nil;
    }
    
}


@end
