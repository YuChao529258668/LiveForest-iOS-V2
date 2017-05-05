//
//  HSNavigationHistoryMenu.m
//  LiveForest
//
//  Created by 余超 on 16/1/19.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSNavigationHistoryMenu.h"
#import "UIView+HSController.h"

@implementation HSNavigationHistoryMenu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HSNavigationHistoryMenu" owner:nil options:nil].lastObject;
        self.width = [UIScreen mainScreen].bounds.size.width;

        self.triangle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_menu_triangle"]];
        self.triangle.contentMode = UIViewContentModeCenter;
        [self addSubview:self.triangle];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _triangle.y = -_triangle.height;
}

#pragma mark - Actions
- (IBAction)yueBanHistoryBtnClick:(UIButton *)sender {
    if (_yueBanHistoryBtnClick) {
        _yueBanHistoryBtnClick();
    }
    _yueBanHistoryBtnClick = nil;
    [self removeFromSuperview];
}

- (IBAction)challengeHistoryBtnClick:(UIButton *)sender {
    if (_challengeHistoryBtnClick) {
        _challengeHistoryBtnClick();
    }
    _challengeHistoryBtnClick = nil;
    [self removeFromSuperview];
}

//- (void)dealloc {
//    HSLog(@"HSNavigationHistoryMenu 释放了");
//}

@end
