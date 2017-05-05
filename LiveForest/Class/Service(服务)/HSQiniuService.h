//
//  HSQiniuService.h
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSHttpRequestTool.h"

@interface HSQiniuService : HSHttpRequestTool

#pragma mark - 上传图片
#pragma mark 根据URL先下载再上传
+ (void)uploadImageWithImageUrl:(NSString*)url andRequestCB:(requestCallBack)CallBack;

#pragma mark 直接上传UIImage
+ (void)uploadImageWithNSData:(NSData*)data
                  andFileName:(NSString*)fileName
                 andRequestCB:(requestCallBack)CallBack;

+ (void)uploadImage:(UIImage *)image
           fileName:(NSString*)fileName
          requestCB:(requestCallBack)CallBack;

@end
