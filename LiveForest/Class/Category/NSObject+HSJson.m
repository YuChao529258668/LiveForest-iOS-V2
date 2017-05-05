//
//  NSObject+HSJson.m
//  LiveForest
//
//  Created by 余超 on 15/12/1.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "NSObject+HSJson.h"

@implementation NSObject (HSJson)

- (id)hs_JsonString {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:1 error:&error];
    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    HSLog(@"%@",dataStr);
//    {
//        "user_token" : "bH4KuBbwiopfrAE2qfpC0hPMnZ7kfjRF1oBw8E3DD2Fk3D",
//        "share_id" : "0",
//        "requestNum" : "6"
//    }
    
    if (error) {
        HSLog(@"%s,%@",__func__,error);
        return self;
    }
    return dataStr;
}
//    id hs_JsonString = [NSJSONSerialization JSONObjectWithData:data options:1 error:&error];
//    HSLog(@"%@",hs_JsonString);


@end
