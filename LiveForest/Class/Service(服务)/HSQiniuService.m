//
//  HSQiniuService.m
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSQiniuService.h"
#import "HSDataFormatHandle.h"
#import <QiniuSDK.h>

@implementation HSQiniuService

+ (void)uploadImageWithImageUrl:(NSString*)url andRequestCB:(requestCallBack)CallBack{

    //首先根据路径下载
    UIImageView* tempUIImageView = [[UIImageView alloc]init];
    
    //进行图片下载
    [HSDataFormatHandle getImageWithUri:url isYaSuo:true imageTarget:tempUIImageView defaultImage:[UIImage imageNamed:@"default"] andRequestCB:^(UIImage *image){
        
        if(image){
            //如果下载并且解压缩成功，将图片转化为NSData
            NSData* dataImag = UIImageJPEGRepresentation(image, 1);
            
            [self uploadImageWithNSData:dataImag andFileName:url andRequestCB:CallBack];
            
        }else{
            //否则直接回调报错
            return CallBack(false,nil,@"图片下载失败");
        
        }
        
    }];
    
}

+ (void)uploadImageWithNSData:(NSData*)data
                 andFileName:(NSString*)fileName
                andRequestCB:(requestCallBack)CallBack
{

    //初始化七牛上传服务器
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    //获取后台的上传Key
    NSString *urlForQiniu = [NSString stringWithFormat:@"%s%s",requestPrefixURL,getQiniuUpToken];
    
    NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
    
    NSDictionary *requestDataForQiniu = @{@"requestData"  : [dic hs_JsonString]};
    
    //获取七牛的数据
    [self getDataWithParameters:requestDataForQiniu andURL:urlForQiniu andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //获取成功，进行上传
            NSString *saveKey = [responseObject objectForKey:@"saveKey"];
            NSString *upToken = [responseObject objectForKey:@"upToken"];
            [upManager putData:data
                           key:saveKey
                         token:upToken
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if(resp){
                              //如果上传成功
                              
                              [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_logo_img"]; //直接存取到本地
                              
                              NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
                              //用户头像url持久化
                              
                              [[NSUserDefaults standardUserDefaults] setObject:imgUrl  forKey:@"user_logo_url"];
                              
                              return CallBack(true, imgUrl,@"");
                          }
                      }
                        option:nil
             ];
        }
        else{
            HSLog(@"%@",error);
            return CallBack(false,nil,@"获取七牛失败");
        }
    }];
}

+ (void)uploadImage:(UIImage *)image
           fileName:(NSString*)fileName
          requestCB:(requestCallBack)CallBack {
    NSData *data = UIImagePNGRepresentation(image);
    [self uploadImageWithNSData:data andFileName:fileName andRequestCB:CallBack];
}

@end
