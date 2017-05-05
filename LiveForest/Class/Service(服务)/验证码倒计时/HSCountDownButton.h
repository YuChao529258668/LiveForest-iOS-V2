//
//  HSCountDownButton.h
//  验证码倒计时按钮
//  LiveForest
//
//  Created by wangfei on 8/3/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSCountDownButton;
typedef NSString* (^DidChangeBlock)(HSCountDownButton *countDownButton,int second);
typedef NSString* (^DidFinishedBlock)(HSCountDownButton *countDownButton,int second);

typedef void (^TouchedDownBlock)(HSCountDownButton *countDownButton,NSInteger tag);

@interface HSCountDownButton : UIButton

{
    int _second;
    
    int _totalSecond;
    
    NSTimer *_timer;
    
    NSDate *_startDate;
    
    DidChangeBlock _didChangeBlock;
    DidFinishedBlock _didFinishedBlock;
    TouchedDownBlock _touchedDownBlock;
}

-(void)addToucheHandler:(TouchedDownBlock)touchHandler;

-(void)didChange:(DidChangeBlock)didChangeBlock;

-(void)didFinished:(DidFinishedBlock)didFinishedBlock;

/**
 *  定时器开始
 *
 *  @param second 自己设置的倒计时时间
 */
-(void)startWithSecond:(int)second;
- (void)stop;

@end
