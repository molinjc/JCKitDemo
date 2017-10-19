//
//  JCTableController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCTableController.h"

@interface JCTableController ()

@end

@implementation JCTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"test"];;
}

@end
