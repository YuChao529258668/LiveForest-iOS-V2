//
//  HSEventFlowPersonCell.m
//  LiveForest
//
//  Created by 余超 on 16/4/1.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSEventFlowPersonCell.h"

@implementation HSEventFlowPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_urgeBtn addTarget:self action:@selector(urgeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.separatorInset = UIEdgeInsetsMake(0, 600, 0, 0);
}

- (void)urgeBtnClick:(UIButton *)btn {
    if (btn.isSelected) {
        return;
    }
    btn.selected = YES;
}

@end
