//
//  HSGoods.h
//  LiveForest
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

//http://doc.live-forest.com/eshop/#goods_theme


@interface HSGoods : NSObject

//  urlstr转换后的url。
@property (nonatomic, strong) NSMutableArray *goodsImageURLs;



@property (nonatomic, copy) NSString *goods_category_id;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *goods_shop_price;

@property (nonatomic, copy) NSString *goods_credit;

@property (nonatomic, copy) NSString *goods_create_time;

@property (nonatomic, copy) NSString *goods_number;

@property (nonatomic, copy) NSString *goods_market_price;

@property (nonatomic, copy) NSString *goods_update_time;

@property (nonatomic, strong) NSArray *goods_logo;

@property (nonatomic, copy) NSString *goods_sn;

@property (nonatomic, copy) NSString *goods_external_link;

@property (nonatomic, copy) NSString *brand_id;

@property (nonatomic, copy) NSString *goods_single_maximum;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *goods_brief;

@property (nonatomic, copy) NSString *goods_desc;

/// 用于演示，kind = 0 或 1，两组数组
+ (NSMutableArray *)test:(NSInteger)kind;

@end
