//
//  HSCommentCell.h
//  LiveForest
//
//  Created by 余超 on 16/1/29.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class HSShareCommentModel;

@interface HSCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
//@property (nonatomic, strong) HSShareCommentModel *model;

+ (instancetype)commentCell;

@end
