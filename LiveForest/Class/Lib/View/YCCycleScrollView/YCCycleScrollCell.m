//
//  YCCycleScrollCell.m
//  LiveForest
//
//  Created by 余超 on 15/12/28.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "YCCycleScrollCell.h"
#import "HSChallengeModel.h"
#import "HSUserModel.h"

// 被点击就发出通知
NSString *const YCCycleScrollCellCheckButtonClickNotification = @"YCCycleScrollCellCheckButtonClickNotification";

@implementation YCCycleScrollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _canSelected = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleClickNotification:) name:YCCycleScrollCellCheckButtonClickNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YCCycleScrollCellCheckButtonClickNotification object:nil];
}

//- (void)setCanSelected:(BOOL)canSelected {
//    _canSelected = canSelected;
//}

- (void)setModel:(HSChallengeModel *)model {
    _model = model;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@发起的挑战",model.user_creator.user_nickname];
    _contentLabel.text = model.challenge_content;
    _timeLabel.text = model.deadlineDateString; // 11月11日 22:00
    _awardLabel.text = model.challenge_reward_text;
}

- (void)handleClickNotification:(NSNotification *)notification {
    if (notification.object != self) {
        self.checkBtn.selected = NO;
    }
}

- (IBAction)checkBtnClick:(UIButton *)sender {
    if (_canSelected == NO) {
        return;
    }
    
    sender.selected = !sender.isSelected;
    
//    发出点击的通知
    NSDictionary *dic = @{@"HSChallengeModel":self.model};
    [[NSNotificationCenter defaultCenter] postNotificationName:YCCycleScrollCellCheckButtonClickNotification object:self userInfo:dic];
}

@end
