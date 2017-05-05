//
//  HSPersonalHeadCell.m
//  LiveForest
//
//  Created by 余超 on 16/1/5.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSPersonalHeadCell.h"
#import "HSUserModel.h"

@implementation HSPersonalHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
}

/// 配置关注按钮的选中状态
- (void)configAttentionBtn {
    //    获取当前用户的关注的人列表
    [HSUserModel getFollowingListWithUserID:[HSUserModel currentUser].user_id success:^(NSArray *models) {
        _attentionBtn.selected = NO; // 假设还没关注某个用户_userID
        for (HSUserModel *user in models) {
            // 相等意味着当前用户已经关注过_userID
            if ([user.user_id isEqualToString:_userID]) {
                _attentionBtn.selected = YES;
                break;
            }
        }
    } failure:^(NSString *error) {
        _attentionBtn.hidden = YES; // 无法判断就隐藏该按钮
        HSLog(@"%s,%@",__func__, error);
    }];
}

- (void)setUserID:(NSString *)userID {
    _userID = [userID copy];
    
    [self configAttentionBtn];
}

- (void)setCanLookPersonDetail:(BOOL)canLookPersonDetail {
    _canLookPersonDetail = canLookPersonDetail;
    _detailImageView.hidden = !canLookPersonDetail;
    _personDetailBtn.hidden = !canLookPersonDetail;
}

- (IBAction)followBtnClick:(UIButton *)sender {
//    如果已关注
    if (sender.isSelected) {
        [HSUserModel followCancelPerson:_userID success:^{
            sender.selected = !sender.isSelected;
        } failure:^(NSString *error) {
            HSLog(@"%s,%@",__func__, error);
            ShowHint(error);
        }];
    } else {
//        如果没关注
        [HSUserModel followPerson:_userID success:^{
            sender.selected = !sender.isSelected;
        } failure:^(NSString *error) {
            HSLog(@"%s,%@",__func__, error);
            ShowHint(error);
        }];
    }
}

@end
