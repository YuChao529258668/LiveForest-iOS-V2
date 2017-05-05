//
//  HSShopTheme.h
//  LiveForest
//
//  Created by 余超 on 15/12/7.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSShopTheme : NSObject

@property (nonatomic, strong) NSURL *goodsThemeLogoURL;



@property (nonatomic, copy) NSString *goods_theme_title;

@property (nonatomic, strong) NSArray *goods_ids;

@property (nonatomic, assign) NSInteger goods_theme_id;

@property (nonatomic, copy) NSString *goods_theme_logo;

@property (nonatomic, copy) NSString *goods_theme_description;

/// 用于演示
+ (NSMutableArray *)test;

@end

//goods_theme_id	Number	主题活动，某一系列的商品的集合
//goods_theme_title	String	该主题活动的标题，譬如“好货来袭”
//goods_theme_description	String	活动的描述，譬如：不要钱，真的不要钱
//goods_theme_logo	String	活动的宣传照片地址
//goods_ids	JSONArray	活动关联的商品的列表
//goods_theme_state	Number	该活动的状态 0 - 尚未开始 1 - 正在进行 2 - 已关闭
//goods_theme_create_time	String	活动的创建时间
