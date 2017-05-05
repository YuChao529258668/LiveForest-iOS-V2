//
//  HSYueBanHistoryController.m
//  LiveForest
//
//  Created by 余超 on 16/1/25.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSYueBanHistoryController.h"
#import "HSYueBanModel.h"
#import "HSYueBanHistoryCell.h"

@interface HSYueBanHistoryController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *inviteMeBtn;
@property (weak, nonatomic) IBOutlet UIButton *iCreateBtn;
@property (nonatomic, strong) NSArray *yueBans;
@property (nonatomic, strong) NSMutableArray *yueBansInviteMe;
@property (nonatomic, strong) NSMutableArray *yueBansICreate;

@end

@implementation HSYueBanHistoryController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getYueBanList];

    self.yueBansInviteMe = @[].mutableCopy;
    self.yueBansICreate = @[].mutableCopy;
    self.yueBans = self.yueBansInviteMe;
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
//    return 8;
        return self.yueBans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSYueBanHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSYueBanHistoryCell" forIndexPath:indexPath];
    cell.yueBan = _yueBans[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

#pragma mark - Data Source
- (void)getYueBanList {
    //    获取我参加的，也就是邀请我的
    [HSYueBanModel getYueBansAttendSuccess:^(NSArray *models) {
        //        _yueBansInviteMe = models;
        [_yueBansInviteMe addObjectsFromArray:models];
        [_tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
    
    //    获取我发起的
    [HSYueBanModel getYueBansCreateSuccess:^(NSArray *models) {
        //        _yueBansICreate = models;
        [_yueBansICreate addObjectsFromArray:models];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
}

#pragma mark - Actions
- (IBAction)inviteMeBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    _iCreateBtn.selected = NO;
    
    _yueBans = _yueBansInviteMe;
    [_tableView reloadData];
}

- (IBAction)iCreateBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    _inviteMeBtn.selected = NO;
    
    _yueBans = _yueBansICreate;
    [_tableView reloadData];
}

@end
