//
//  HSShareDetailCell.h
//  LiveForest
//
//  Created by 余超 on 15/12/24.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSRecommendShareModel;

@interface HSShareDetailCell : UITableViewCell

@property (strong, nonatomic) HSRecommendShareModel *recommendShareModel;


@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (nonatomic, copy) void (^postShareLikeBlock) (NSString *shareID);

///为了在cell的外部触发按钮的点击事件，设计师真是多余啊
- (void)likeBtnClick;

@end
