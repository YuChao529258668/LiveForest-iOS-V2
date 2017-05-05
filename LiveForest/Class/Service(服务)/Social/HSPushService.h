//
//  HSPushService.h
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 负责接收推送并且进行
@interface HSPushService : NSObject

+(Boolean)initService;

+(Boolean)handleUserInfo:(NSDictionary*)userInfo;

@end
