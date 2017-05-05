//
//  HSSportLableModel.h
//  WFAddUIView
//
//  Created by wangfei on 7/13/15.
//  Copyright (c) 2015 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSSportModel : NSObject
/**
 *  运动id
 */
@property (nonatomic, copy) NSString *sportID;
/**
 *  运动名称
 */
@property (nonatomic, copy) NSString *sportName;
/**
 *  普通图片
 */
@property (nonatomic, copy) NSString *normalIcon;
/**
 *  选择状态图片
 */
@property (nonatomic, copy) NSString *selectedIcon;
/**
 *  状态是否是选中的
 */
@property (nonatomic, assign) BOOL isSelected;
-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)sportModelWithDic:(NSDictionary *)dict;
+(NSArray *)sportModels;
@end
