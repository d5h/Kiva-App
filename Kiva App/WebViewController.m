//
//  WebViewController.m
//  Kiva App
//
//  Created by Afzal Syed on 3/17/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kiva.org/basket/set"]];
    
    NSDictionary *basketData = [[NSDictionary alloc]initWithObjectsAndKeys:
                                @"106975", @"id",
                                @"25", @"amount",
                                nil];
   // NSDictionary *loansData = [[NSDictionary alloc]initWithObjectsAndKeys:basketData, @"loans", nil];
    
    NSArray *basketArray = [[NSArray alloc]initWithObjects:basketData, nil];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:basketArray options:NSJSONWritingPrettyPrinted error: nil];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];

    [self.webView loadRequest:request];
    
    
    
    
    
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizesSubviews = YES;
    
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:&error];
    NSLog(@"%@", jsonDict);
    
    NSString* jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString: %@", jsonString);
    
    [self.webView loadRequest:request];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
