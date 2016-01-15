//
//  RootViewController.m
//  ColorPicker
//
//  Created by midea on 16/1/15.
//  Copyright (c) 2016年 midea. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[@"圆形", @"矩形", @"环形"];
    self.title = @"颜色拾取器";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showdetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detail = (DetailViewController *)segue.destinationViewController;
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    detail.title = [NSString stringWithFormat:@"%@", self.items[path.row]];
    detail.pickStyle = path.row;
}

@end
