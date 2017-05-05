//
//  HSPickView.h
//  LiveForest
//
//  Created by wangfei on 7/3/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AreaLevelCity = 2,
    AreaLevelDistrict = 3
} AreaLevel;

@interface HSPickView : UIView
@property (nonatomic, copy) NSString *selectedProvince;
@property (nonatomic, copy) NSString *selectedCity;
@property (nonatomic, copy) NSString *selectedCounty;


/**
 *  初始化
 *
 *  @param frame 需要覆盖的父类的视图
 *  @param type  地区几级类型
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithFrame:(CGRect)frame Level:(AreaLevel)type;
-(void)show;
-(void)remove;

@end
