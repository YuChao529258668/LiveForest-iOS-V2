//
//  HSDeviceService.h
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSDeviceService : UIViewController

//高斯模糊
- (UIImage *)blurryImage:(UIImage *)image
           withBlurLevel:(CGFloat)blur;

//获取设备uuid
+(NSString*) getUuid;

@end
