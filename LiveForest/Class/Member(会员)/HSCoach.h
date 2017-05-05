//
//  HSCoach.h
//  LiveForest
//
//  Created by 余超 on 16/8/11.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCoach : NSObject
//@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, copy) NSString *coachID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarUrlStr;

+ (void)getCoachsSuccess:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

@end
