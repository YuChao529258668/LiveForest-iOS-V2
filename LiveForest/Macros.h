//
//  Macros.h
//  HotSNS
//
//  Created by Payne on 15-3-28.
//  Copyright (c) 2015年 李长远. All rights reserved.
//
#import "MBProgressHUD+MJ.h"
#import "HSConstantURL.h"
#ifndef HotSNS_Macros_h
#define HotSNS_Macros_h

#pragma mark -
#pragma mark UIColor

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue) UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b) UIColorFromRGBA(r,g,b,1.0)

//定义全局的Notification Name
#define notifyAppDelegateRootViewControllerNotification @"notifyAppDelegateRootViewControllerNotification";

#pragma mark - 变量类型定义
typedef void (^requestCallBack)(BOOL code, id responseObject,NSString *error);

#pragma mark - Global Methods
#pragma mark Center View

static inline void CenterView(UIView *v, UIView *superV)
{
    CGPoint origin = CGPointMake((superV.frame.size.width - v.frame.size.width)/2,
                                 (superV.frame.size.height - v.frame.size.height)/2);
    
    v.frame = CGRectMake(origin.x, origin.y, v.frame.size.width, v.frame.size.height);
}

static inline void CenterViewX(UIView *v, UIView *superV)
{
    CGPoint origin = CGPointMake((superV.frame.size.width - v.frame.size.width)/2,
                                 v.frame.origin.y);
    
    v.frame = CGRectMake(origin.x, origin.y, v.frame.size.width, v.frame.size.height);
}

#pragma mark - Global Methods
#pragma mark 提示框

static inline void ShowHud(NSString * infoString,BOOL isSuccess)
{
    //新版本的显示
    [MBProgressHUD ShowHud:infoString];
}

static inline void ShowHint(NSString * infoString)
{
    //新版本的显示
    [MBProgressHUD ShowHud:infoString];
}



#endif
