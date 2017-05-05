//
//  HSCoach.m
//  LiveForest
//
//  Created by 余超 on 16/8/11.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSCoach.h"
#import <BmobSDK/Bmob.h>

@implementation HSCoach

+ (void)getCoachsSuccess:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure {
    BmobQuery *bq = [[BmobQuery alloc]initWithClassName:@"Coach"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            HSLog(@"%s,%@",__func__, error.localizedDescription);
        } else {
            NSMutableArray *coachs = @[].mutableCopy;
            HSCoach *coach;
            
            for (BmobObject *obj in array) {
                coach = [HSCoach new];
                coach.coachID = [obj objectForKey:@"coachID"];
                coach.name = [obj objectForKey:@"nickName"];
                coach.avatarUrlStr = [obj objectForKey:@"avatar"];
                [coachs addObject:coach];
            }

            if (success) {
                success(coachs);
            }
        }
    }];
}

@end
