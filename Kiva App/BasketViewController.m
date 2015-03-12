//
//  BasketViewController.m
//  Kiva App
//
//  Created by Syed, Afzal on 3/11/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

#import "BasketViewController.h"
#import "BasketCell.h"

@interface BasketViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BasketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEdit)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Checkout" style:UIBarButtonItemStylePlain target:self action:@selector(onCheckout)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BasketCell" bundle:nil] forCellReuseIdentifier:@"BasketCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setBasketLoans:(NSMutableArray *)basketLoans {
    _basketLoans = basketLoans;
    [self.tableView reloadData];
    
}

#pragma mark - Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.basketLoans.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BasketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasketCell"];
    cell.loan = self.basketLoans[indexPath.row];
    return cell;
    
}

- (void) onEdit {
    
}

- (void) onCheckout {
    
}
@end
