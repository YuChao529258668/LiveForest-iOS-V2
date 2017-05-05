//
//  HSNotificationListController.m
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSNotificationListController.h"
#import "HSPersonalNotification.h"
#import "HSNotificationCell.h"
#import "HSNavigationTool.h"

@interface HSNotificationListController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<__kindof HSPersonalNotification *> *notifications;
@end

@implementation HSNotificationListController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getNotificationList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSNotificationCell" forIndexPath:indexPath];
    cell.notification = _notifications[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSPersonalNotification *noti = _notifications[indexPath.row];
    NSUInteger type = noti.notificationType;
    switch (type) {
        case HSPersonalNotificationTypeShare:
            [HSNavigationTool pushShareDetailViewControllerWithResourceID:noti.notification_resource_id From:self];
            break;
        case HSPersonalNotificationTypeChallenge:
            
            break;
        case HSPersonalNotificationTypeGoods:
            
            break;
        case HSPersonalNotificationTypeYueBan:
            
            break;
        case HSPersonalNotificationTypeError:
            ShowHint(@"数据有误，界面无法跳转");
            HSLog(@"%s,%@",__func__, @"通知界面无法跳转");
            break;
    }
}

#pragma mark - Data Source
- (void)getNotificationList {
    [HSPersonalNotification getNotificationListSuccess:^(NSArray *notifications) {
        _notifications = notifications;
        [_tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
}

@end
