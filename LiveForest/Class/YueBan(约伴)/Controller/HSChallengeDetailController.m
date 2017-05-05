//
//  HSChallengeDetailController.m
//  LiveForest
//
//  Created by 余超 on 15/12/15.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSChallengeDetailController.h"
#import "HSChallengeEventFlowController.h"
#import "HSShareDetailController.h"

#import "YCCountDownView.h"
#import "HSSportsCell.h"
#import "HSEventFlowPersonCell.h"

//#import "HSYueBanModel.h"
#import "HSChallengeModel.h"
#import "HSUserModel.h"
#import "HSRecommendShareModel.h"
#import "HSChallengeAttendModel.h"

#import "HSHttpRequestTool.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "UIImageView+HSSetImage.h"

@interface HSChallengeDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) YCCountDownView *countDownView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) HSSportsCellStyle sportsCellStyle;
@property (nonatomic, assign) BOOL shouldHideFinishBtn;
@property (nonatomic, assign) BOOL shouldHideAcceptChallengeBtn;
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, strong) NSArray<__kindof HSChallengeAttendModel *> *challengeAttends;
@end

@implementation HSChallengeDetailController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButtons];
    [self setupYCCountDownView];
    
    [self configerView];
    [self getChallengeAttendList];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 528;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Setup
- (void)setupYCCountDownView {
//    截止日期
//    NSTimeInterval deadline = [[NSDate date] timeIntervalSince1970] + 60;
    NSTimeInterval deadline = self.challengeModel.challenge_deadline.doubleValue;

//    CGRect frame = CGRectMake(0, 0, 375, 198);
    CGSize size = [_countDownContainView systemLayoutSizeFittingSize:_countDownContainView.size];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);

    __weak HSChallengeDetailController *weakself = self;
    
//    创建倒计时
    YCCountDownView *countDownView = [YCCountDownView viewWithFrame:frame deadline:deadline timeOutBlock:^{
        weakself.acceptChallengeBtn.userInteractionEnabled = NO;
    }];
    _countDownView = countDownView;
    
//    设置center
//    CGSize size = _countDownContainView.frame.size;
    float x = size.width / 2;
    float y = size.height / 2;
    CGPoint center = CGPointMake(x, y);
    _countDownView.center = center;
    
    [_countDownContainView addSubview:_countDownView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize size = [_countDownContainView systemLayoutSizeFittingSize:_countDownContainView.size];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    _countDownView.frame = frame;
}

- (void)setupButtons {
    [self.acceptChallengeBtn addTarget:self action:@selector(acceptChallengeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.finishBtn.hidden = YES;
}

#pragma mark - Actions
- (void)acceptChallengeBtnClick:(UIButton *)btn {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定参加挑战？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self attendChallenge];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:acceptAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)finishBtnClick:(UIButton *)btn {
    [self finishChallenge];
}

#pragma mark - Data Source
- (void)getChallengeAttendList {
    [HSChallengeAttendModel getChallengeAttendsWithChallengeID:_challengeID success:^(NSArray *models) {
        _challengeAttends = models;
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
    
//    [HSRecommendShareModel getShareListWithUserID:nil challengeID:self.challengeID Success:^(NSArray *activitys) {
//        
//    } failure:^(NSString *error) {
//        HSLog(@"%s,%@",__func__, error);
//    }];
}

- (void)attendChallenge {
    [_challengeModel attendChallengeSuccess:^{
        ShowHint(@"参与成功");
        self.challengeModel.isAttend = YES;
        self.acceptChallengeBtn.hidden = YES;
        self.finishBtn.hidden = NO;
        [self.acceptChallengeBtn removeFromSuperview];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } failure:^(NSString *error) {
        ShowHint(error);
        HSLog(@"%s,%@",__func__, error);
    }];
}

- (void)finishChallenge {
    [_challengeModel finishChallengeSuccess:^{
        ShowHint(@"完成挑战");
        self.finishBtn.hidden = YES;
        [self.finishBtn removeFromSuperview];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } failure:^(NSString *error) {
        ShowHint(error);
        HSLog(@"%s,%@",__func__, error);
    }];
}

#pragma mark - UITableViewDataSource
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        return @"未完成";
//    } else {
//        return @"";
//    }
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        CGRect frame = CGRectMake(0, 0, 200, 20);
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"    未完成" attributes:dic];
        label.attributedText = str;
//        return label;
        return nil;
    } else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.challengeAttends.count;
    } else {
//        return self.challengeModel.challenge_user_id_invited.count;
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    分享简介
    if (indexPath.section == 0) {
        HSSportsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSSportsCell" forIndexPath:indexPath];
        cell.challengeAttendModel = self.challengeAttends[indexPath.row];
        cell.sportsCellStyle = self.sportsCellStyle;
        cell.postShareLikeBlock = ^(NSString *shareID) {
            [HSHttpRequestTool postShareLike:shareID success:^{
                HSLog(@"%s,%@",__func__, @"点赞成功");
            } failure:^(NSString *error) {
                HSLog(@"%s,%@",__func__, error);
            }];
        };
        cell.moreContentsBtnClickBlock = ^ {
            HSChallengeEventFlowController *vc = [HSChallengeEventFlowController challengeEventFlowController];
//            vc.backgroundView = [self.view snapshotViewAfterScreenUpdates:NO];
            HSRecommendShareModel *model = self.challengeAttends[indexPath.row].share;
            if (model.share_in_challenge_id == nil) {
                model.share_in_challenge_id = @"400";
            }
            vc.shareModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.completeChallengeBtnClickBlock = ^{
            [self.challengeModel finishChallengeSuccess:^{
                self.challengeAttends[indexPath.row].challenge_attend_state = 2;
            } failure:^(NSString *error) {
                HSLog(@"%s,%@",__func__, error);
                ShowHint(error);
            }];
        };
        cell.kanHaoBtnClickBlock = ^{
            [self.challengeModel onlookChallengeWithKanHao:@"1" Success:^{
                
            } failure:^(NSString *error) {
                HSLog(@"%s,%@",__func__, error);
            }];
        };
        cell.buKanHaoBtnClickBlock = ^{
            [self.challengeModel onlookChallengeWithKanHao:@"0" Success:^{
                
            } failure:^(NSString *error) {
                HSLog(@"%s,%@",__func__, error);
            }];
        };
        return cell;
    }
    else {
        HSEventFlowPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSEventFlowPersonCell" forIndexPath:indexPath];
        cell.userNameLabel.text = self.challengeModel.challenge_user_id_invited[indexPath.row];
        if (_userStyle == HSChallengeUserStyleCreator) {
            cell.urgeBtn.hidden = NO;
        } else {
            cell.urgeBtn.hidden = YES;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
//        return 40;
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HSShareDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShareDetailController"];
    
    vc.recommendShareModel = self.challengeAttends[indexPath.row].share;
    [self.navigationController pushViewController:vc animated:YES];
    //    [self presentViewController:vc animated:YES completion:nil];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:reuseIdentifier configuration:^(id cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"pushToHSChallengeDetailController" sender:indexPath];
//}

#pragma mark - Helper
- (void)configerView {
//    暂时把完成挑战的按钮去掉。
    [self.finishBtn removeFromSuperview];
    self.finishBtn = nil;
    
    self.finishBtn.hidden = self.shouldHideFinishBtn;
    self.acceptChallengeBtn.hidden = self.shouldHideAcceptChallengeBtn;
    
    switch (self.userStyle) {
        case HSChallengeUserStyleCreator:
//            显示参与者列表，显示完成按钮，显示催促按钮，隐藏看好和不看好按钮
            self.titleLabel.text = @"你 发起挑战";

            [self.acceptChallengeBtn removeFromSuperview];
            [self.view setNeedsLayout];
            break;
        case HSChallengeUserStylePlayer:
            self.titleLabel.text = [NSString stringWithFormat:@"%@ 挑战你", self.challengeModel.user_creator.user_nickname];
            break;
        case HSChallengeUserStyleOnlooker:
            self.titleLabel.text = [NSString stringWithFormat:@"%@ 挑战", self.challengeModel.user_creator.user_nickname];

            [self.acceptChallengeBtn removeFromSuperview];
            [self.view setNeedsLayout];
            break;
        case HSChallengeUserStyleNone:
            self.titleLabel.text = [NSString stringWithFormat:@"%@ 挑战你", self.challengeModel.user_creator.user_nickname];
            [self.acceptChallengeBtn removeFromSuperview];
            [self.view setNeedsLayout];

            break;

    }
    
    self.contentLabel.text = _challengeModel.challenge_content;
    [self.avatarImageView hs_setAvatarWithURLStr:_challengeModel.user_creator.user_logo_img_path];
    [self.avatarImageView hs_clipsToRound];
    self.userNameLabel.text = _challengeModel.user_creator.user_nickname;
    self.messageTV.text = _challengeModel.challenge_text_info;
    self.scoreLabel.text = _challengeModel.challenge_reward_credit;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@积分", self.scoreLabel.text];
    self.rewardLabel.text = _challengeModel.challenge_reward_text;
}

#pragma mark - Set
- (void)setChallengeModel:(HSChallengeModel *)challengeModel {
    _challengeModel = challengeModel;
    
    self.challengeID = challengeModel.challenge_id;
}

- (void)setUserStyle:(HSChallengeUserStyle)userStyle {
    _userStyle = userStyle;
    
    switch (userStyle) {
        case HSChallengeUserStyleCreator:
            self.sportsCellStyle = HSSportsCellStyleCreator;
            _shouldHideFinishBtn = YES;
            _shouldHideAcceptChallengeBtn = YES;
            _sectionCount = 2;
            break;
        case HSChallengeUserStylePlayer:
            self.sportsCellStyle = HSSportsCellStylePlayer;
            _shouldHideFinishBtn = YES;
            _shouldHideAcceptChallengeBtn = NO;
            _sectionCount = 1;
            break;
        case HSChallengeUserStyleOnlooker:
            self.sportsCellStyle = HSSportsCellStyleOnlooker;
            _shouldHideFinishBtn = YES;
            _shouldHideAcceptChallengeBtn = YES;
            _sectionCount = 2;
            break;
        case HSChallengeUserStyleNone:
            self.sportsCellStyle = HSSportsCellStyleNone;
            _shouldHideFinishBtn = YES;
            _shouldHideAcceptChallengeBtn = YES;
            _sectionCount = 1;
            break;
    }
}

@end
