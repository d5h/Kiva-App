//
//  LoansSearchFilterForm.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/8/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "LoansSearchFilterForm.h"
#import "ISO3166CountryValueTransformer.h"


@implementation LoansSearchFilterForm




- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.status = [[dictionary objectForKey:@"status"] componentsSeparatedByString:@","];
        self.gender = [dictionary objectForKey:@"gender"];
        self.region = [[dictionary objectForKey:@"region"] componentsSeparatedByString:@","];
        self.sortBy = [dictionary objectForKey:@"sort_by"];
        self.country = [[dictionary objectForKey:@"country_code"] componentsSeparatedByString:@","];
    }
    
    return self;
}



- (NSDictionary *)statusField {
    return @{FXFormFieldInline: @YES, FXFormFieldOptions: @[
                     @"fundraising",
                     @"funded",
                     @"in_repayment",
                     @"paid",
                     @"ended_with_loss",
                     @"expired",
                     ],
             
             FXFormFieldValueTransformer: ^(id input) {
                 return @{@"fundraising": @"Fundraising",
                          @"funded": @"Funded",
                          @"in_repayment": @"In Repayment",
                          @"paid": @"Paid",
                          @"ended_with_loss": @"Ended With Loss",
                          @"expired": @"Expired",

                          }[input];
                 
             }};
}




- (NSDictionary *)genderField {
    return @{FXFormFieldInline: @YES, FXFormFieldOptions: @[
                     @"male",
                     @"female",
                     ],
             
             FXFormFieldValueTransformer: ^(id input) {
                 return @{@"male": @"Male",
                          @"female": @"Female",
                          }[input];

             }};

}

- (NSDictionary *)regionField {
    return @{FXFormFieldInline: @YES, FXFormFieldOptions: @[
                     @"na",
                     @"ca",
                     @"sa",
                     @"af",
                     @"as",
                     @"me",
                     @"ee",
                     @"oc",
                     ],
             FXFormFieldValueTransformer: ^(id input) {
                 return @{@"na": @"North America",
                          @"ca": @"Central America",
                          @"sa": @"South America",
                          @"af": @"Africa",
                          @"as": @"Asia",
                          @"me": @"Middle East",
                          @"ee": @"Eastern Europe",
                          @"oc": @"Oceania",
                          }[input];
                 
             }};
}

- (NSDictionary *)countryField {
    return @{FXFormFieldOptions: @[@"AF", @"AL", @"AM", @"AZ", @"BA", @"BF", @"BG", @"BI", @"BJ", @"BO", @"BR", @"BW", @"BZ", @"CD", @"CG", @"CI", @"CL", @"CM", @"CN", @"CO", @"CR", @"DO", @"EC", @"EG", @"GE", @"GH", @"GT", @"HN", @"HT", @"ID", @"IL", @"IN", @"IQ", @"JO", @"KE", @"KG", @"KH", @"LA", @"LB", @"LK", @"LR", @"MD", @"MG", @"ML", @"MM", @"MN", @"MR", @"MW", @"MX", @"MZ", @"NA", @"NG", @"NI", @"NP", @"PA", @"PE", @"PG", @"PH", @"PK", @"PS", @"PY", @"RW", @"SB", @"SG", @"SL", @"SN", @"SO", @"SR", @"SV", @"TD", @"TG", @"TH", @"TJ", @"TL", @"TN", @"TR", @"TZ", @"UA", @"UG", @"US", @"VC", @"VN", @"VU", @"WS", @"XK", @"YE", @"ZA", @"ZM", @"ZW"],
             FXFormFieldValueTransformer: [[ISO3166CountryValueTransformer alloc] init]};
}

- (NSDictionary *)sortByField {
    return @{FXFormFieldInline: @YES, FXFormFieldOptions: @[
                     @"popularity",
                     @"loan_amount",
                     @"expiration",
                     @"newest",
                     @"oldest",
                     @"amount_remaining",
                     @"repayment_term",
                     @"random",
                     ],
             FXFormFieldValueTransformer: ^(id input) {
                 return @{@"popularity": @"Popularity",
                          @"loan_amount": @"Loan Amount",
                          @"expiration": @"Expiration",
                          @"newest": @"Newest",
                          @"oldest": @"Oldest",
                          @"amount_remaining": @"Amount Remaining",
                          @"repayment_term": @"Repayment Term",
                          @"random": @"Random",
                          }[input];
                 
             }};
}



- (NSDictionary *)dictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.status.count > 0) {
        NSString *statusFilter = [self.status componentsJoinedByString:@","];
        [result setObject:statusFilter forKey:@"status"];    }
    if (self.gender) {
        [result setObject:self.gender forKey:@"gender"];
    }
    if (self.sortBy) {
        [result setObject:self.sortBy forKey:@"sort_by"];
    }
    if (self.region.count >0) {
        NSString *regionFilter = [self.region componentsJoinedByString:@","];
        [result setObject:regionFilter forKey:@"region"];    }
    
    if (self.country.count > 0) {
        NSString *countryFilter = [self.country componentsJoinedByString:@","];
        [result setObject:countryFilter forKey:@"country_code"];
    }
    
    
    return result;
}



@end