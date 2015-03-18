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
@property (nonatomic, strong) NSURLRequest *urlRequest;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *loan1 = @{ @"id" : @"854446",
                             @"amount" : @"100"
                             };
    NSDictionary *loan2 = @{ @"id" : @"849651",
                             @"amount" : @"25"
                             };
    NSDictionary *loanDict = @{@"loans" : @[loan1, loan2],
                               @"donation" : @"10.00"
                               };
    
    
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    self.urlRequest = [requestSerializer requestWithMethod:@"POST"
                                                      URLString:@"http://www.kiva.org/basket/set"
                                                     parameters:loanDict error:nil];
    
    [self.webView setScalesPageToFit:YES];
    
    /* This loadRequest:progress: method, automatically sets up a
     * UIWebView with the correct requests and delegation methods */
    [self.webView loadRequest:self.urlRequest
                                progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) { /* not needed in this example */ }
                                 success:^NSString *(NSHTTPURLResponse *response, NSString *HTML)
    {
        NSLog(@"The response URL: %@ ", response.URL);
        return HTML;
    } failure:^(NSError *error)
    {
        NSLog(@"error: %@", error);
    } ];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
