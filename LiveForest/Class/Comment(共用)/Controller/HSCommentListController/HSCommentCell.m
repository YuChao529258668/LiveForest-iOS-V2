//
//  HSCommentCell.m
//  LiveForest
//
//  Created by 余超 on 16/1/29.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSCommentCell.h"

@implementation HSCommentCell

+ (instancetype)commentCell {
    HSCommentCell *cell = [[NSBundle mainBundle] loadNibNamed:@"HSCommentCell" owner:nil options:nil].lastObject;
    return cell;
}

@end
