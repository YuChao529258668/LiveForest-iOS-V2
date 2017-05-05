//
//  YCTextView.m
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "YCTextView.h"

@implementation YCTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // 创建占位符视图
    _placeholderView = [[UITextView alloc]init];
    _placeholderView.userInteractionEnabled = NO;
    _placeholderView.backgroundColor = [UIColor clearColor];
    _placeholderView.text = @"写点什么吧。。。";
    _placeholderView.textColor = self.defaultPlaceholderColor;
    _placeholderView.font = self.font;
    [self addSubview:_placeholderView];

    // 如果故事板有text，就隐藏占位符
    if (self.text.length>0) {
        _placeholderView.alpha = 0;
    }
    
    // 监听text的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

// 处理text的变化
- (void)textDidChange {
    if (self.text.length > 0) {
        _placeholderView.alpha = 0;
    } else {
        _placeholderView.alpha = 1;
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderView.text = placeholder;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    // 如果不是特殊的占位符，那么占位符的字体和text的字体相同。
    if (self.attributedText == nil) {
        _placeholderView.font = font;
    }
}

- (UIColor *)defaultPlaceholderColor {
//    方法1：
//    UITextField *tf = [UITextField new];
//    tf.placeholder = @"123";
//    UIColor *color = [tf valueForKey:@"_placeholderLabel.textColor"];
//    NSLog(@"%@",color.description);
//    UIDeviceRGBColorSpace 0 0 0.0980392 0.22
//    return color;
    
    return [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.22];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    _placeholderView.frame = frame;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
