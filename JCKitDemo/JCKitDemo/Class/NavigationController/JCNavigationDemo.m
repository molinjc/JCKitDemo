//
//  JCNavigationDemo.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCNavigationDemo.h"
#import "JCNA1Controller.h"
#import "JCNB1Controller.h"
#import "JCNC1Controller.h"
#import "JCND1Controller.h"

@interface JCNavigationDemo ()
@property (nonatomic, strong) NSArray *titles;
@end

@implementation JCNavigationDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[@"导航栏隐藏时侧滑效果", @"leftBarButtonItem返回", @"透明导航栏", @"全屏侧滑返回", @"关闭全屏侧滑返回"];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    JCViewController *viewController = nil;
    if (indexPath.row == 0) { viewController = [[JCNA1Controller alloc] init]; }
    if (indexPath.row == 1) { viewController = [[JCNB1Controller alloc] init]; }
    if (indexPath.row == 2) { viewController = [[JCNC1Controller alloc] init]; }
    if (indexPath.row == 3) { viewController = [[JCND1Controller alloc] init]; }
    if (indexPath.row == 4) { [self.navigationController fullScreenInteractivePop:NO]; }
    if (viewController) { [self.navigationController pushViewController:viewController animated:YES]; }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}


@end
