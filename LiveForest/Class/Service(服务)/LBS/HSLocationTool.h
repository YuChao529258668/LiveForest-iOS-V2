//
//  HSLocationTool.h
//  LiveForest
//
//  Created by 余超 on 16/2/28.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface HSLocationTool : NSObject

///纬度
@property (nonatomic) double latitude;

///经度
@property (nonatomic) double longitude;

///层次化地址信息。streetNumber 街道号码，streetName 文综路，district 栖霞区，city 南京市，province 江苏省。
@property (nonatomic, strong) BMKAddressComponent* addressDetail;

//        BMKReverseGeoCodeResult
//        ///层次化地址信息
//        @property (nonatomic, strong) BMKAddressComponent* addressDetail;
//        ///地址名称
//        @property (nonatomic, strong) NSString* address; 江苏省南京市栖霞区文宗路
//        ///商圈名称
//        @property (nonatomic, strong) NSString* businessCircle;
//        ///地址坐标
//        @property (nonatomic) CLLocationCoordinate2D location;
///反地址编码结果
@property (nonatomic, strong) BMKReverseGeoCodeResult *reverseGeoCodeResult;

/////地址编码结果
//@property (nonatomic, strong) BMKGeoCodeResult *geoCodeResult;

/// 开启定位服务，然后通过类方法locationTool创建对象访问经纬度等信息，如果定位太慢或失败则信息为空
+ (void)startLocation;

/// 停止定位服务，不用的时候要调用
+ (void)stopLocation;

/// 通过调用startLocation方法获取位置信息
+ (instancetype)locationTool;

@end
