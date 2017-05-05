//
//  HSYChallengeHistoryController.m
//  LiveForest
//
//  Created by 余超 on 16/1/25.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSYChallengeHistoryController.h"
#import "HSChallengeDetailController.h"

#import "HSChallengeModel.h"

#import "HSYueBanHistoryCell.h"
#import "HSNavigationTool.h"

@interface HSYChallengeHistoryController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *inviteMeBtn;
@property (weak, nonatomic) IBOutlet UIButton *iCreateBtn;
@property (weak, nonatomic) IBOutlet UIButton *iWatchBtn;

@property (nonatomic, strong) NSArray *challenges;
@property (nonatomic, strong) NSMutableArray *challengesInviteMe;
@property (nonatomic, strong) NSMutableArray *challengesICreate;
@property (nonatomic, strong) NSMutableArray *challengesIWatch;

/// 发起者、挑战者、围观者
@property (nonatomic, assign) HSChallengeUserStyle userStyle;
@end


@implementation HSYChallengeHistoryController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getChallengeList];
    
    self.challengesInviteMe = @[].mutableCopy;
    self.challengesICreate = @[].mutableCopy;
    self.challengesIWatch = @[].mutableCopy;
    self.challenges = self.challengesInviteMe;
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
//    return self.yueBanModels.count;
    return _challenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSYueBanHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSYueBanHistoryCell" forIndexPath:indexPath];
    cell.challenge = _challenges[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [HSNavigationTool pushChallengeDetailViewControllerWithResource:self.challenges[indexPath.row] style:_userStyle from:self];
}

#pragma mark - Data Source
// 切换数据源数组的时候，要注意指针的陷阱，所以只好用NSMutableArray
- (void)getChallengeList {
//    获取我参加的，也就是邀请我的
    [HSChallengeModel getChallengesAttendSuccess:^(NSArray *models) {
//        _challengesInviteMe = models;
        [_challengesInviteMe addObjectsFromArray:models];
        [_tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
    
//    获取我发起的
    [HSChallengeModel getChallengesCreateSuccess:^(NSArray *models) {
//        _challengesICreate = models;
        [_challengesICreate addObjectsFromArray:models];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
    
//    获取我围观的
    [HSChallengeModel getChallengesOnLookSuccess:^(NSArray *models) {
//        _challengesIWatch = models;
        [_challengesIWatch addObjectsFromArray:models];
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
    _iWatchBtn.selected = NO;
    
    _challenges = _challengesInviteMe;
    [_tableView reloadData];

//    _userStyle = HSChallengeUserStylePlayer;
    _userStyle = HSChallengeUserStyleNone;
}

- (IBAction)iCreateBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    _inviteMeBtn.selected = NO;
    _iWatchBtn.selected = NO;
    
    _challenges = _challengesICreate;
    [_tableView reloadData];
    
    _userStyle = HSChallengeUserStyleCreator;
}

- (IBAction)iWatchBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    _inviteMeBtn.selected = NO;
    _iCreateBtn.selected = NO;
    
    _challenges = _challengesIWatch;
    [_tableView reloadData];
    
    _userStyle = HSChallengeUserStyleOnlooker;
}

@end
