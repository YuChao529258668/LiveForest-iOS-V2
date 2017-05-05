//
//  HSUserInfoCacheTool.m
//  LiveForest
//
//  Created by 余超 on 16/9/12.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSUserInfoCacheTool.h"
#import "HSUserModel.h"
#import "HSCoach.h"
#import "HSNotificationTool.h"

//static NSMutableDictionary *namesDic;
//static NSMutableDictionary *avatarsDic;

static HSUserInfoCacheTool *tool;



@interface HSUserInfoCacheTool ()
@property (nonatomic, strong) NSMutableDictionary *namesDic;
@property (nonatomic, strong) NSMutableDictionary *avatarsDic;

@property (nonatomic, strong) NSMutableArray *downloadings;
@end



@implementation HSUserInfoCacheTool

//+ (void)initialize
//{
//    if (self == [HSUserInfoCacheTool class]) {
//        tool = [HSUserInfoCacheTool new];
//    }
//}

+ (void)load {
    [super load];
    
    tool = [HSUserInfoCacheTool new];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadings = @[].mutableCopy;
        
        [self readNamesAndAvatars];
        [self getCoachsFromBmob];
        
        [HSNotificationTool addLoginObserver:self selector:@selector(handleLoginSuccessNotification) object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self writeNamesAndAvatars];
    
    [HSNotificationTool removeLoginObserver:self object:nil];
}

#pragma mark - Helper

- (void)readNamesAndAvatars {
    NSString *catchPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask , YES).firstObject;
    HSLog(@"%@", catchPath);
    NSString *file1 = [catchPath stringByAppendingPathComponent:@"names"];
    NSString *file2 = [catchPath stringByAppendingPathComponent:@"avatars"];

    self.namesDic = [NSMutableDictionary dictionaryWithContentsOfFile:file1];
    self.avatarsDic = [NSMutableDictionary dictionaryWithContentsOfFile:file2];
    
    if (!self.namesDic) {
        self.namesDic = @{}.mutableCopy;
        self.avatarsDic = @{}.mutableCopy;
    }
}

- (void)writeNamesAndAvatars {
    NSString *catchPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask , YES).firstObject;
    HSLog(@"%@", catchPath);
    NSString *file1 = [catchPath stringByAppendingPathComponent:@"names"];
    NSString *file2 = [catchPath stringByAppendingPathComponent:@"avatars"];
    [self.namesDic writeToFile:file1 atomically:YES];
    [self.avatarsDic writeToFile:file2 atomically:YES];
}

- (void)handleLoginSuccessNotification {
    HSUserModel *user = [HSUserModel currentUser];
    [self.namesDic setObject:user.user_nickname forKey:user.user_id];
    [self.avatarsDic setObject:user.user_logo_img_path forKey:user.user_id];
}

#pragma mark - Data Source

- (void)getUserInfoWithUserID:(NSString *)userID {
    if ([self.downloadings containsObject:userID]) {
        return;
    }
    
    [self.downloadings addObject:userID];
    
    [HSUserModel getUserInfoWithUserID:userID success:^(HSUserModel *userInfo) {
        [self setAvatarUrl:userInfo.user_logo_img_path nickName:userInfo.user_nickname withUserID:userID];
        [self.downloadings removeObject:userID];
    } failure:^(NSString *error) {
        [self.downloadings removeObject:userID];
    }];
}

- (void)getCoachsFromBmob {
    [HSCoach getCoachsSuccess:^(NSArray *array) {
        for (HSCoach *coach in array) {
            [self setAvatarUrl:coach.avatarUrlStr nickName:coach.name withUserID:coach.coachID];
        }
    } failure:^(NSError *error) {
        // 失败后尝试获取两次
        static int times = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (times < 2) {
                times ++;
                [self getCoachsFromBmob];
            } else {
                times = 0;
            }
        });
    }];
}

#pragma mark - Public

+ (void)setAvatarUrl:(NSString *)url nickName:(NSString *)name withUserID:(NSString *)userID {
    [self setAvatarUrl:url nickName:name withUserID:userID];
}

+ (NSString *)nickNameForUser:(NSString *)userID {
    return [tool nickNameForUser:userID];
}

+ (NSString *)avatarUrlForUser:(NSString *)userID {
    return [tool avatarUrlForUser:userID];
}

#pragma mark - Private

- (void)setAvatarUrl:(NSString *)url nickName:(NSString *)name withUserID:(NSString *)userID {
    [self.namesDic setObject:name forKey:userID];
    [self.avatarsDic setObject:url forKey:userID];
}

- (NSString *)nickNameForUser:(NSString *)userID {
//    if ([userID isEqualToString:[HSUserModel currentUser].user_id]) {
//        return [HSUserModel currentUser].user_nickname;
//    }
    
//    NSString *name = [tool nickNameForUser:userID];
    NSString *name = [self.namesDic valueForKey:userID];
    if (!name) {
        [tool getUserInfoWithUserID:userID];
    }

    return name;
}

- (NSString *)avatarUrlForUser:(NSString *)userID {
//    if ([userID isEqualToString:[HSUserModel currentUser].user_id]) {
//        return [HSUserModel currentUser].user_logo_img_path;
//    }
    
//    NSString *avatarUrl = [self.avatarsDic objectForKey:userID];

    return [self.avatarsDic objectForKey:userID];
}


@end
