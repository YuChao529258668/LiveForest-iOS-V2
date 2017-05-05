//
//  YCKeyboardHandler.m
//  LiveForest
//
//  Created by 余超 on 16/1/27.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "YCKeyboardHandler.h"

@implementation YCKeyboardHandler

+ (void)handler {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//UIViewController
}
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
    NSValue *frame = userInfo[UIKeyboardFrameEndUserInfoKey];
    float keyboardHeight = frame.CGRectValue.size.height;
    NSLog(@"%@",userInfo);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.origin = CGPointMake(0, -keyboardHeight);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.origin = CGPointMake(0, 0);
    }];
}
@end
