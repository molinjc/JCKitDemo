//
//  JCRootViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCRootViewController.h"

@interface JCRootViewController ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *controllers;
@end

@implementation JCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JCKit Demo";
    _titles = @[].mutableCopy;
    _controllers = @[].mutableCopy;
    [self addCell:@"导航栏pop动画及全屏侧滑返回" class:@"JCNavigationDemo"];
    [self addCell:@"UI皮肤 Demo" class:@"JCSRootController"];
    [self addCell:@"UI链式编程" class:@"JCChainViewController"];
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_setting"] originalImage] style:UIBarButtonItemStylePlain target:self action:@selector(skinSetup)];
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [_titles addObject:title];
    [_controllers addObject:className];
}

- (void)skinSetup {
    NSString *className = @"JCSkinSetupController";
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > _controllers.count) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    NSString *className = _controllers[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.theme_backgroundColor = [UIColor whiteColor];
        cell.textLabel.theme_textColor = nil;
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

@end
