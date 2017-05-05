//
//  YCCycleScrollCell.h
//  LiveForest
//
//  Created by 余超 on 15/12/28.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSChallengeModel;

// 被点击就发出通知
extern NSString *const YCCycleScrollCellCheckButtonClickNotification;

@interface YCCycleScrollCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, strong) HSChallengeModel *model;

///是否允许选中
@property (nonatomic) BOOL canSelected;
@end
