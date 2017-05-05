//
//  BaiduMapService.h
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>
//引入base相关所有的头文件
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

/** 注意，百度地图的头文件发生了变化
 #import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
 
 #import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
 
 #import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
 
 #import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
 
 #import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
 
 #import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
 
 #import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
 
 #import < BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
 **/

@interface HSBaiduMapService : NSObject<BMKGeneralDelegate>

#pragma mark - 初始化百度地图服务
+(Boolean) initService;

@end
