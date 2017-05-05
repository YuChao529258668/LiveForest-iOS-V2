//
//  HSShareDetailBar.m
//  LiveForest
//
//  Created by 余超 on 15/12/29.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShareDetailBar.h"

@implementation HSShareDetailBar

+ (instancetype)barWithFrame:(CGRect)frame delegate:(id<HSShareDetailBarDelegate>)delegate {
    HSShareDetailBar *bar = [[NSBundle mainBundle]loadNibNamed:@"HSShareDetailBar" owner:nil options:nil].lastObject;
    bar.frame = frame;
    bar.delegate = delegate;
    return bar;
}

- (void)awakeFromNib {
    _backBtn = [self viewWithTag:1];
    _likeBtn = [self viewWithTag:2];
    _commentBtn = [self viewWithTag:3];
    _personBtn = [self viewWithTag:4];
    
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_personBtn addTarget:self action:@selector(personBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions
- (void)backBtnClick:(UIButton *)btn {
    [self.delegate HSShareDetailBar:self backButtonClick:btn];
}
- (void)likeBtnClick:(UIButton *)btn {
    [self.delegate HSShareDetailBar:self likeButtonClick:btn];
//    btn.selected = !btn.isSelected;
}
- (void)commentBtnClick:(UIButton *)btn {
    [self.delegate HSShareDetailBar:self commentButtonClick:btn];
}
- (void)personBtnClick:(UIButton *)btn {
    [self.delegate HSShareDetailBar:self personButtonClick:btn];
}

@end
