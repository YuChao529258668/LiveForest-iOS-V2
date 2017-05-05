//
//  HSLocationTool.m
//  LiveForest
//
//  Created by 余超 on 16/2/28.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSLocationTool.h"

static HSLocationTool *tool;

@interface HSLocationTool ()<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKLocationService *locService; // 百度地图定位服务
@property (nonatomic, strong) BMKGeoCodeSearch *searcher; // 百度地图反编码搜索结果
@end


@implementation HSLocationTool

#pragma mark - 类方法
+ (instancetype)locationTool {
    return tool;
}

+ (void)startLocation {
    tool = [HSLocationTool new];
}

+ (void)stopLocation {
    tool = nil;
}

#pragma mark - 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBaiDuMap];
    }
    return self;
}

- (void)dealloc
{
    [self stopBaiDuMapService];
}

#pragma mark - Helper
- (void)setupBaiDuMap {
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    //初始化BMKGeoCodeSearch
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    //启动LocationService
    [_locService startUserLocationService];
}

//    停止百度地图服务
- (void)stopBaiDuMapService {
    _searcher.delegate = nil;
    _locService.delegate = nil;
    [_locService stopUserLocationService];
}

/**
 *  发起反向地理编码检索，在 onGetReverseGeoCodeResult 函数获取结果
 */
- (void)reverseGeoCode {
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_latitude, _longitude};
    BMKReverseGeoCodeOption *option = [BMKReverseGeoCodeOption new];
    option.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:option];
    if(!flag) {
        HSLog(@"反geo检索发送失败");
    }
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    _latitude = userLocation.location.coordinate.latitude; // 纬度
    _longitude = userLocation.location.coordinate.longitude; // 经度
    
    //发起反向地理编码检索
    [self reverseGeoCode];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    HSLog(@"定位失败");
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        self.reverseGeoCodeResult = result;
        self.addressDetail = result.addressDetail;
        
//        addressDetail
//        /// 街道号码
//        @property (nonatomic, strong) NSString* streetNumber; @""
//        /// 街道名称
//        @property (nonatomic, strong) NSString* streetName;文综路
//        /// 区县名称
//        @property (nonatomic, strong) NSString* district;栖霞区
//        /// 城市名称
//        @property (nonatomic, strong) NSString* city;南京市
//        /// 省份名称
//        @property (nonatomic, strong) NSString* province;江苏省
        
//        BMKReverseGeoCodeResult
//        ///层次化地址信息
//        @property (nonatomic, strong) BMKAddressComponent* addressDetail;
//        ///地址名称
//        @property (nonatomic, strong) NSString* address; 江苏省南京市栖霞区文宗路
//        ///商圈名称
//        @property (nonatomic, strong) NSString* businessCircle;
//        ///地址坐标
//        @property (nonatomic) CLLocationCoordinate2D location;

    } else {
        HSLog(@"抱歉，未找到结果");
    }
}

@end
