//
//  HSSelectGoodsCountView.m
//  LiveForest
//
//  Created by 余超 on 16/3/2.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSSelectGoodsCountView.h"

@interface HSSelectGoodsCountView ()
@property (nonatomic, strong) UIButton *decreaseBtn;
@property (nonatomic, strong) UIButton *increaseBtn;
@property (nonatomic, strong) UILabel *countLabel;
@end


@implementation HSSelectGoodsCountView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setup {
    float width = 104;
    float height = 32;
    
    _decreaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 32)];
    [_decreaseBtn setImage:[UIImage imageNamed:@"btn_decrease1"] forState:UIControlStateNormal];
    [_decreaseBtn addTarget:self action:@selector(decreaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _increaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 32, 0, 34, 32)];
    [_increaseBtn setImage:[UIImage imageNamed:@"btn_plus1"] forState:UIControlStateNormal];
    [_increaseBtn addTarget:self action:@selector(creaseBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 34, 32)];
    _countLabel.center = CGPointMake(width/2, height/2);
    _countLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_number"]];
    _countLabel.text = @"2";
    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.frame = frame; // 没有效果，还是故事板的大小
    
    [self addSubview:_decreaseBtn];
    [self addSubview:_increaseBtn];
    [self addSubview:_countLabel];
}

- (void)decreaseBtnClick {
    int count = _countLabel.text.intValue;
    if (count > 1) {
        count --;
    }
    _countLabel.text = [NSString stringWithFormat:@"%d",count];
}

- (void)creaseBtnClick {
    int count = _countLabel.text.intValue;
    count ++;
    _countLabel.text = [NSString stringWithFormat:@"%d",count];
}

- (int)count {
    return _countLabel.text.intValue;
}

@end
