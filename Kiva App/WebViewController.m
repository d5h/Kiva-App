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
    
    NSDictionary *loan1 = @{ @"id" : @(854446),
                             @"amount" : @(100)
                             };
    NSDictionary *loan2 = @{ @"id" : @(849651),
                             @"amount" : @(25)
                             };
    NSDictionary *loanDict = @{@"loans" : @[loan1, loan2],
                               @"app_id" : @"com.drrajan.cp-kiva-app",

                               @"donation" : @"30.00",
                               };
    
    //NSData *json = [NSJSONSerialization dataWithJSONObject:loanDict
      //                                             options:NSUTF8StringEncoding
        //                                             error:nil];
    //NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    

    
    NSString *testString = @"loans=[{\"id\":845118,\"amount\":25}]&app_id=in.thoughtvine.kiva&donation=0.000000";
    
        NSLog(@"loans array is %@", testString);

    
        NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kiva.org/basket/set"]];
        //NSData *postData = [NSJSONSerialization dataWithJSONObject:loanDict options:NSJSONWritingPrettyPrinted error: nil];
        [request setHTTPMethod:@"POST"];
    NSData* data = [testString dataUsingEncoding:NSUTF8StringEncoding];

        [request setHTTPBody:data];
        [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];

    //
    //    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    //    self.urlRequest = [requestSerializer requestWithMethod:@"POST"
    //                                                 URLString:@"http://www.kiva.org/basket/set"
    //                                                parameters:testString error:nil];
    //
    
    //
    //
    //    /* This loadRequest:progress: method, automatically sets up a
    //     * UIWebView with the correct requests and delegation methods */
    //    [self.webView loadRequest:self.urlRequest
    //                     progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) { /* not needed in this example */ }
    //                      success:^NSString *(NSHTTPURLResponse *response, NSString *HTML)
    //     {
    //         NSLog(@"The response URL: %@ ", response.URL);
    //         return HTML;
    //     } failure:^(NSError *error)
    //     {
    //         NSLog(@"error: %@", error);
    //     } ];
    
//
//    self.loadIdsSet = [NSMutableSet set];
//    
//    if ([self getFromDefaults:@"loadIdsSet"] != nil) {
//        self.loadIdsSet = [self getFromDefaults:@"loadIdsSet"];
//    }
//    
//    // Do any additional setup after loading the view from its nib.
//    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kiva.org/basket/set"]];
//    
//    NSDictionary *basketData = [[NSDictionary alloc]initWithObjectsAndKeys:
//                                self.basketLoanId , @"id",
//                                @"25", @"amount",
//                                nil];
//    NSDictionary *loansData = [[NSDictionary alloc]initWithObjectsAndKeys:basketData, @"loans", nil];
//    
//    NSArray *basketArray = [[NSArray alloc]initWithObjects:loansData, nil];
//    
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:basketArray options:NSJSONWritingPrettyPrinted error: nil];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:postData];
//    
//    
//    [self.loadIdsSet addObject:self.basketLoanId];
//    [self saveToDefault:self.loadIdsSet forKey:@"loadIdsSet"];
//    
//    NSLog(@" loadids are %@" , self.loadIdsSet);
//    
//    
//    
//    
//    
//    
//    self.webView.scalesPageToFit = YES;
//    self.webView.autoresizesSubviews = YES;
//    
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
