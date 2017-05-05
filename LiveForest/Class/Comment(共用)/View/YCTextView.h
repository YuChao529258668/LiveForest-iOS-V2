//
//  YCTextView.h
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//


/*
    实现思路：
    用一个UITextView实现占位符，占位符字体和text的字体相同，两个view的size相等。

    用法：
    1、故事板
    从故事板拖一个UITextView，设置好字体大小颜色等，修改class为YCTextView，故事板修改的属性有效。
    2、代码创建
    和UITextView一样。
*/

#import <UIKit/UIKit.h>

@interface YCTextView : UITextView

/**
 *  占位符视图，默认字体和颜色：
    placeholderView.text.font = self.font;
    placeholderView.textColor = UITextField.占位符默认颜色;
 
    如果要图片占位符，修改placeholderView.attributedText
 */
@property (nonatomic, strong) UITextView *placeholderView;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong, readonly) UIColor *defaultPlaceholderColor;

@end
