//
//  YCBadgeView.m
//  LiveForest
//
//  Created by 余超 on 16/9/9.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "YCBadgeView.h"

@interface YCBadgeView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation YCBadgeView


+ (instancetype)badgeViewWithValue:(NSString *)value {
    
    if (value.integerValue > 99) {
        value = @"99+";
    }
    
    //    CGRect rect = CGRectMake(0, 0, 18, 18);  8.5 16, 16 16;     18 18, 26 18;

    NSInteger length = value.length;
    float width = 10 + length * 8;
//    float labelWidth = 10 + (length - 1) * 10;
    float labelWidth = length * 10;
    
    CGRect rect = CGRectMake(0, 0, width, 18);
    CGRect labelRect = CGRectMake(0, 0, labelWidth, 16);
    
    YCBadgeView *view = [[YCBadgeView alloc]initWithFrame:rect labelFrame:labelRect];
    view.label.text = value;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame labelFrame:(CGRect)labelFrame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(self.width / 2, self.height / 2);
    self.label.center = center;
    
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] set];
    
    float width = rect.size.width;
    float height = rect.size.height;
    
    CGRect rect1 = CGRectMake(0, 0, height, height);
    CGRect rect2 = CGRectMake(height / 2, 0, width - height, height);
    CGRect rect3 = CGRectMake(width - height, 0, height, height);
    
    // 画圆
    CGContextFillEllipseInRect(ctx, rect1);
    CGContextFillEllipseInRect(ctx, rect3);
    
    // 画正方形
    CGContextFillRect(ctx, rect2);
}

@end
