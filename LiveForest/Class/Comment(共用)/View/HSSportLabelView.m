//
//  HSLabelView.m
//  WFAddUIView
//
//  Created by wangfei on 7/11/15.
//  Copyright (c) 2015 wangfei. All rights reserved.
//

#import "HSSportLabelView.h"
@interface HSSportLabelView()
/**
 *  是否单选
 */
@property (nonatomic, assign)BOOL isSingleSelection;
@end
@implementation HSSportLabelView

-(instancetype)initWithIsSingleSelect:(BOOL)isSingleSelection
{
    self = [super init];
    if (self) {
        self.isSingleSelection = isSingleSelection;
        [self addSubview:self.sportButton];
        [self addSubview:self.sportLable];
    }
    return self;
}
-(UIButton *)sportButton
{
    if (_sportButton == nil) {
        _sportButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_sportButton addTarget:self action:@selector(clickButton:)forControlEvents:UIControlEventTouchUpInside];
    }
    return _sportButton;
}
-(UILabel *)sportLable
{
    if (_sportLable == nil) {
        _sportLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 50, 10)];
        _sportLable.font = [UIFont systemFontOfSize:11.0];
        _sportLable.textColor = [UIColor grayColor];
        _sportLable.textAlignment = NSTextAlignmentCenter;
    }
    return _sportLable;
}
-(void)clickButton:(UIButton *)button
{
    

    //如果当前的按钮就是选中的，直接换状态，单选就关闭
    if (button.selected == YES) {
        //选择减一
        [[NSNotificationCenter defaultCenter] postNotificationName: @"tagNoPickedNotification" object: nil];

        button.selected = !button.selected;
        //如果是单选，选完直接关闭界面（代理）关闭界面
        if(self.isSingleSelection){
            if ([self.delegate respondsToSelector:@selector(sportLaleViewDidClose:)]) {
                [self.delegate sportLaleViewDidClose:self];
            }
        }

    }else{
        //只要选择了按钮，就通知，以判断是否选择
        //选择加一
        [[NSNotificationCenter defaultCenter] postNotificationName: @"tagPickedNotification" object: nil];
        //如果是单选，清除以前的选择
        if(self.isSingleSelection){
            if ([self.delegate respondsToSelector:@selector(sportLalelViewDidClickButton:)]) {
                [self.delegate sportLalelViewDidClickButton:self];
            }
        }
        //选中自己
        button.selected = !button.selected;
        //单选就直接关闭视图
        if(self.isSingleSelection){
            if ([self.delegate respondsToSelector:@selector(sportLaleViewDidClose:)]) {
                [self.delegate sportLaleViewDidClose:self];
            }
        }
    }
    
}
@end
