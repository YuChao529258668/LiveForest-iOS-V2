//
//  HSAreaTool.h
//  LiveForest
//
//  Created by 余超 on 16/2/28.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSAreaTool : NSObject

/**
 *  由地区ID获得地区的详细描述，没有中国这一级
 *  市一级--返回 江苏南京市，上海，北京
 *  区一级--放回 江苏南京市鼓楼区，上海闵行区，北京海淀区
 *  @param stringID 后台获得的地区ID
 *
 *  @return 描述
 */
-(NSString *)areaFormatHandleWithStringID:(NSString *)stringID;

/**
 *  由传入的省市区信息返回地区ID
 *  江苏  南京市 鼓楼区
 *  @param province 省份，没有传入nil
 *  @param city     市
 *  @param district 区，县 不为nil时，前面市必须有信息，否则不能保证唯一性
 *
 *  @return 地区ID
 */
-(NSString *)areaIDFormatHandleWithProvince:(NSString *)province City:(NSString *)city District:(NSString *)district;

@end
