//
//  HSUserInfoCacheTool.h
//  LiveForest
//
//  Created by 余超 on 16/9/12.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSUserInfoCacheTool : NSObject

+ (void)setAvatarUrl:(NSString *)url nickName:(NSString *)name withUserID:(NSString *)userID;
+ (NSString *)nickNameForUser:(NSString *)userID;
+ (NSString *)avatarUrlForUser:(NSString *)userID;


@end
