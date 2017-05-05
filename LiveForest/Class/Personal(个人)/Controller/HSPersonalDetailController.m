//
//  HSPersonalDetailController.m
//  LiveForest
//
//  Created by 余超 on 16/3/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSPersonalDetailController.h"
#import "HSSelectedFriendController.h"
#import "HSModifyPersonalInfoController.h"

#import "HSUserTool.h"
#import "HSUserModel.h"
#import "HSHttpRequestTool.h"

#import "HSLoginLogic.h"

@interface HSPersonalDetailController ()
@property (nonatomic, strong) NSMutableArray *friends;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *iFollowLabel;
@property (weak, nonatomic) IBOutlet UILabel *followMeLabel;
@property (weak, nonatomic) IBOutlet UIButton *yuebanBtn;
@property (weak, nonatomic) IBOutlet UIButton *challengeBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

@end

@implementation HSPersonalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.width/2;
    _avatarImageView.clipsToBounds = YES;

    [HSUserTool setUserAvatar:self.avatarImageView];
    _nameLabel.text = [HSUserModel currentUser].user_nickname;
    _signLabel.text = [HSUserModel currentUser].user_sign;
    _iFollowLabel.text =  [NSString stringWithFormat:@"%@", [HSUserModel currentUser].user_following_num];
    _followMeLabel.text = [NSString stringWithFormat:@"%@", [HSUserModel currentUser].user_fans_num];
    
    [self getUserStatistics];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if ([HSUserModel currentUser].modifyAvatar) {
//        _avatarImageView.image = [HSUserModel currentUser].modifyAvatar;
//    }
    if ([HSUserModel currentUser].modifyAvatarData) {
        _avatarImageView.image = [UIImage imageWithData:[HSUserModel currentUser].modifyAvatarData];
    }
    _nameLabel.text = [HSUserModel currentUser].user_nickname;
    _signLabel.text = [HSUserModel currentUser].user_sign;

    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - Data Source
- (void)getUserStatistics {
    // 用于演示
    HSUserModel *user = self.user;
    [_yuebanBtn setTitle:[NSString stringWithFormat:@"%@", user.yuebanCount] forState:UIControlStateNormal];
    [_challengeBtn setTitle:[NSString stringWithFormat:@"%@", user.challengeCount] forState:UIControlStateNormal];
    [_orderBtn setTitle:[NSString stringWithFormat:@"%@", user.orderCount] forState:UIControlStateNormal];
    _followMeLabel.text = [NSString stringWithFormat:@"%@", user.user_fans_num];
    _iFollowLabel.text = [NSString stringWithFormat:@"%@", user.user_following_num];
    [HSUserTool setUserAvatarWithURLString:user.user_logo_img_path imageView:_avatarImageView];

    return;
    
    
    [HSUserModel getUserStatisticsWithUserID:[HSUserModel userID] success:^{
        HSUserModel *user = [HSUserModel currentUser];
        [_yuebanBtn setTitle:[NSString stringWithFormat:@"%@", user.yuebanCount] forState:UIControlStateNormal];
        [_challengeBtn setTitle:[NSString stringWithFormat:@"%@", user.challengeCount] forState:UIControlStateNormal];
        [_orderBtn setTitle:[NSString stringWithFormat:@"%@", user.orderCount] forState:UIControlStateNormal];
    } failure:^(NSString *error) {
            HSLog(@"%s,%@",__func__, error);
    }];
}

#pragma mark - Actions

//- (IBAction)modifyBtnClick:(UIButton *)sender {
//}

- (IBAction)feedbackBtnClick:(UIButton *)sender {
    ShowHint(@"摇一摇手机");
}

- (IBAction)inviteFriendBtnClick:(UIButton *)sender {
    ShowHint(@"敬请期待");
//    HSSelectedFriendController *vc = [HSSelectedFriendController selectedFriendController];
//    
//    vc.selectedFriends = self.friends;
//    vc.completeBlock = ^(NSArray *friends){
//        sender.selected = friends.count>0? YES: NO;
//        self.friends = [friends copy];
//    };
//    
//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)modifyBtnClick:(UIButton *)sender {
    HSModifyPersonalInfoController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HSModifyPersonalInfoController"];
//    vc.didModifyAvatarBlock = ^(UIImage *avatar) {
//        self.avatarImageView.image = avatar;
//    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logoutBtnClick:(UIButton *)sender {
    [HSLoginLogic doLogOut];

}

@end
