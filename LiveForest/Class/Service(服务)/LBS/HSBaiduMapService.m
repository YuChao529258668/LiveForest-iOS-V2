//
//  BaiduMapService.m
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSBaiduMapService.h"

@implementation HSBaiduMapService

#pragma mark - 静态方法
+(Boolean) initService{
    
    //初始化控制器
    BMKMapManager* _mapManager = [[BMKMapManager alloc] init];
    
    //初始化百度地图
//    BOOL ret = [_mapManager start:@"kT8UIQ5othxi3t3rxwSGwwIm"  generalDelegate:self];
    BOOL ret = [_mapManager start:@"xIEIF0ACrlATmB1XQuuvtNU5"  generalDelegate:self];
    
    if (!ret) {
        NSLog(@"badidu map manager start failed!");
        return false;
    }
    
    return YES;
}

#pragma mark 百度地图启动合法性检测delegate

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}
/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
