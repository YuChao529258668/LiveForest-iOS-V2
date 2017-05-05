//
//  HSSportsCell.h
//  LiveForest
//
//  Created by 余超 on 15/12/2.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

typedef NS_ENUM(NSInteger, HSSportsCellStyle) {
    HSSportsCellStyleNone = 0,
    HSSportsCellStylePlayer = 1,
    HSSportsCellStyleOnlooker = 2,
    HSSportsCellStyleCreator = 3
};

#import <UIKit/UIKit.h>
@class HSRecommendShareModel;
@class HSChallengeAttendModel;

@interface HSSportsCell : UITableViewCell

@property (strong, nonatomic) HSRecommendShareModel *recommendShareModel;
@property (nonatomic, strong) HSChallengeAttendModel *challengeAttendModel;
@property (nonatomic, assign) HSSportsCellStyle sportsCellStyle;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

/// 查看该分享关联的挑战的其他分享
@property (weak, nonatomic) IBOutlet UIButton *moreContentsBtn;

/// 确认挑战完成按钮
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

/// 看好
@property (weak, nonatomic) IBOutlet UIButton *kanHaoBtn;
/// 不看好
@property (weak, nonatomic) IBOutlet UIButton *buKanHaoBtn;
/// 已看好/不看好
@property (weak, nonatomic) IBOutlet UILabel *onlookStateLabel;


@property (nonatomic, copy) void (^postShareLikeBlock) (NSString *shareID);
@property (nonatomic, copy) void (^moreContentsBtnClickBlock) ();

@property (nonatomic, copy) void (^completeChallengeBtnClickBlock) ();
@property (nonatomic, copy) void (^kanHaoBtnClickBlock) ();
@property (nonatomic, copy) void (^buKanHaoBtnClickBlock) ();
@end

