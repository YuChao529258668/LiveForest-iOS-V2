//
//  HSRecommendShareModel.m
//  LiveForest
//
//  Created by 余超 on 15/12/4.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSRecommendShareModel.h"
#import "HSDataFormatHandle.h"
#import "HSHttpRequestTool.h"

#import <objc/runtime.h>

@interface HSRecommendShareModel ()<NSCoding>

@end

@implementation HSRecommendShareModel

#pragma mark - Test
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSRecommendShareModel *m = [HSRecommendShareModel new];
    m.share_in_challenge_nums = @2;
    m.share_description = @"这是分享描述，巴拉巴拉小魔仙";
    m.share_like_num = 3;
    m.comment_count = @"5";
    m.createTime = @"2017-5-12";
    m.sport_ids = @"13";
    m.share_img_path_with_lables = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493720129500&di=cad74c9655f4781c0f779d6abdf7ecba&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2Fd52a2834349b033bca660d4215ce36d3d439bdb8.jpg";
    m.user_nickname = @"小红";
    m.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    m.share_img_path = @[@"http://www.kuaihou.com/uploads/allimg/130130/1-1301300103061P.jpg",
                         @"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
                         @"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
                         @"http://t1.niutuku.com/960/22/22-435778.jpg",
                         @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
                         @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
                         @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
                         @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
                         @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];
    
    
    HSRecommendShareModel *m2 = [HSRecommendShareModel new];
    m2.share_in_challenge_nums = @22;
    m2.share_description = @"这是分享描述，巴拉巴拉小魔仙";
    m2.share_like_num = 33;
    m2.comment_count = @"45";
    m2.createTime = @"2017-5-12";
    m2.sport_ids = @"12";
    m2.share_img_path_with_lables = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493725893388&di=bac27eccd72c1e717700daa8a0038bcd&imgtype=0&src=http%3A%2F%2Fimage15.poco.cn%2Fmypoco%2Fmyphoto%2F20130911%2F18%2F1741652072013091118115104.jpg";
    m2.user_nickname = @"小红";
    m2.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    m2.share_img_path = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493725893388&di=bac27eccd72c1e717700daa8a0038bcd&imgtype=0&src=http%3A%2F%2Fimage15.poco.cn%2Fmypoco%2Fmyphoto%2F20130911%2F18%2F1741652072013091118115104.jpg",
                         @"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
                         @"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
                         @"http://t1.niutuku.com/960/22/22-435778.jpg",
                         @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
                         @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
                         @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
                         @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
                         @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];

    
    [array addObject:m];
    [array addObject:m2];
    [array addObject:m];
    [array addObject:m2];
    [array addObject:m];
    [array addObject:m2];
    
    return array;
}

+ (void)modifyImagePath:(NSArray *)array {
//    NSString *urlstr = @"http://a.hiphotos.baidu.com/image/pic/item/64380cd7912397dd81eae4055b82b2b7d0a2871b.jpg";
//    for (HSRecommendShareModel *model in array) {
//        model.firstContentImagePath = [NSURL URLWithString:urlstr];
//    }
}

#pragma mark - DataSource

// 获取推荐的分享列表
+ (void)getRecommendShareListWithPageNum:(int)num PageSize:(int)size Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
//    NSString *urlStr = @"http://api.liveforest.com/Social/Share/getRecommendShareList";
    NSString *urlStr = @"http://api.liveforest.com/Social/Share/getMPShareList";
    NSString *user_token = [HSHttpRequestTool userToken];
    NSDictionary *para = @{@"user_token" : user_token,
                           @"pageNum" : @(num),
                           @"pageSize" : @(size)};
    
    [HSHttpRequestTool GET:urlStr parameters:para class:self.class key:@"shareList" success:^(NSArray *objects) {
//        [self modifyImagePath:objects];
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

// 获取某个用户的分享列表
+ (void)getUserShareListWithUserID:(NSString *)userID shareID:(int)share_id requestNum:(NSUInteger)number Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlStr = @"http://api.liveforest.com/Social/Share/getShareList";
    NSString *user_token = [HSHttpRequestTool userToken];
    NSDictionary *para = @{@"user_token" : user_token,
                           @"user_id": userID,
                           @"share_id" : @(share_id),
                           @"pageSize" : @(number)};
    
    [HSHttpRequestTool GET:urlStr parameters:para class:self.class key:@"shareList" success:^(NSArray *objects) {
        [self modifyImagePath:objects];
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

+ (void)getShareListWithUserID:(NSString *)userID challengeID:(NSString *)challengeID Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure {
    NSString *urlStr = @"http://api.liveforest.com/Social/Share/getShareList";
    NSString *user_token = [HSHttpRequestTool userToken];
    NSDictionary *para = @{@"user_token" : user_token,
                           @"user_id": userID,
                           @"challenge_id" : challengeID};
    
    [HSHttpRequestTool GET:urlStr parameters:para class:self.class key:@"shareList" success:^(NSArray *objects) {
        [self modifyImagePath:objects];
        success(objects);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

#pragma mark - NSCoding 
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        Ivar var = ivarList[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        
        if ([type hasPrefix:@"@"] == NO) {
            continue;
        }
        
        id obj = object_getIvar(self, var);
        
        [aCoder encodeObject:obj forKey:name];
//        NSLog(@"i = %d, %@, %@",i, name, obj);
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList([self class], &count);
        
        for (int i = 0; i<count; i++) {
            Ivar ivar = ivarList[i];
            NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:name];
            
            object_setIvar(self, ivar, value);
//            NSLog(@"%@, %@",name,value);

        }
    }
    return self;
}

#pragma mark - Overrite
- (NSString *)description {
    //    return [NSString stringWithFormat:@"%@,%ld,%@",self.user_nickname,(long)self.share_comment_num,self.comment_count];
    return [NSString stringWithFormat:@"share_id = %@",self.share_id];
}

- (BOOL)isEqual:(id)object {
    HSLog(@"%s",__func__);
    
    NSString *shareID = [object valueForKey:@"share_id"];

    if ([self.share_id isEqualToString: shareID]) {
        return YES;
    }
    return NO;
}

#pragma mark - Set
- (void)setUser_logo_img_path:(NSString *)user_logo_img_path {
    _user_logo_img_path = user_logo_img_path;
    
    self.avatarPath = [NSURL hs_URLWithString:user_logo_img_path];
}

- (void)setShare_img_path:(NSArray<NSString *> *)share_img_path {
    _share_img_path = share_img_path;
    
    self.firstContentImagePath = [NSURL hs_URLWithString: share_img_path[0]];
}

- (void)setShare_like_num:(NSInteger)share_like_num {
    _share_like_num = share_like_num;
    
    self.likesCount = [NSString stringWithFormat:@"%ld",(long)share_like_num];
}

- (void)setShare_location:(NSString *)share_location {
    _share_location = share_location;
    if ([_share_location isEqualToString:@"-10086"] || [_share_location isEqualToString:@""]) {
        _share_location = @" ";
    } else {
        _share_location = [NSString stringWithFormat:@"#%@",share_location];
    }
}

- (void)setUser_nickname:(NSString *)user_nickname {
    _user_nickname = user_nickname;
    
    if ([_user_nickname isEqualToString:@"-10086"] || [_user_nickname isEqualToString:@""]) {
        _user_nickname = @"官方推荐";
    }
}

- (void)setSport_ids:(NSString *)sport_ids {
    _sport_ids = sport_ids;
    
    if ([_sport_ids isEqualToString:@"-10086"]) {
        _sport_ids = @" ";
    }
    
    self.activityName = [HSDataFormatHandle sportFormatHandleWithSportID:_sport_ids];
}

- (void)setShare_create_time:(NSString *)share_create_time {
    _share_create_time = share_create_time;
    self.createTime = [HSDataFormatHandle dateFormaterString:self.share_create_time];
}

//- (NSString *)createTime {
//    NSString *time = [HSDataFormatHandle dateFormaterString:self.share_create_time];
//    return time;
//}


@end
