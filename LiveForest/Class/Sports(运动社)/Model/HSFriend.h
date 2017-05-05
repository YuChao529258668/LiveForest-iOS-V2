//
//  HSFriend.h
//  LiveForest
//
//  Created by 余超 on 16/2/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSFriend : NSObject

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_nickname;
@property (nonatomic, copy) NSString *user_logo_img_path;
@property (nonatomic, copy) NSString *user_sex;
@property (nonatomic, copy) NSString *user_introduction;

+ (void)getFriendListSuccess:(void(^)(NSArray *friends))success failure:(void(^)(NSString *error))failure;

@end
