//
//  HSShareDetailController.h
//  LiveForest
//
//  Created by 余超 on 15/12/24.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSRecommendShareModel;

@interface HSShareDetailController : UIViewController
/// 赋值会修改shareID属性
@property (nonatomic, strong) HSRecommendShareModel *recommendShareModel;
/// 用来获取后台数据
@property (nonatomic, copy) NSString *shareID;
@end
