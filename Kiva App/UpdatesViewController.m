//
//  UpdatesViewController.m
//  Kiva App
//
//  Created by Dan Hipschman on 3/10/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "UpdatesViewController.h"
#import "KivaClientO.h"
#import "SVProgressHUD.h"

@interface UpdatesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UpdatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Updates";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JournalEntryCell" bundle:nil] forCellReuseIdentifier:@"JournalEntryCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 1000;
    
    // TODO: Look up user's loans and all journal entries for them, or some highly
    // recommended journal entries
    [SVProgressHUD show];
    [[KivaClientO sharedInstance] fetchUpdatesForLoan:76950 completion:^(NSArray *journalEntries, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            self.journalEntries = journalEntries;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters

- (void)setJournalEntries:(NSArray *)journalEntries {
    _journalEntries = journalEntries;
    [self.tableView reloadData];
}

#pragma mark - Table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.journalEntries.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JournalEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JournalEntryCell"];
    cell.journalEntry = self.journalEntries[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
