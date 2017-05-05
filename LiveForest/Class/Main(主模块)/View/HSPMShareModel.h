//
//  HSPMShareModel.h
//  LiveForest
//
//  Created by 余超 on 15/12/3.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSPMShareModel : NSObject

@property (nonatomic, strong) NSMutableArray *imageURLs;



@property (nonatomic, assign) NSInteger share_like_num;

@property (nonatomic, copy) NSString *delete_state;

@property (nonatomic, copy) NSString *share_category;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *share_create_time;

@property (nonatomic, copy) NSString *sport_ids;

@property (nonatomic, assign) NSInteger share_city;

@property (nonatomic, assign) NSInteger share_id;

@property (nonatomic, copy) NSString *hasLiked;

@property (nonatomic, copy) NSString *share_img_path_with_lables;

@property (nonatomic, copy) NSString *user_nickname;

@property (nonatomic, copy) NSString *share_location;

@property (nonatomic, copy) NSString *user_logo_img_path;

@property (nonatomic, assign) NSInteger share_county;

@property (nonatomic, copy) NSString *share_paster_ids;

@property (nonatomic, assign) CGFloat share_lon;

@property (nonatomic, strong) NSArray<NSString *> *share_img_path;

@property (nonatomic, copy) NSString *share_description;

@property (nonatomic, copy) NSString *share_img_path_with_pasters;

@property (nonatomic, assign) NSInteger comment_count;

@property (nonatomic, assign) CGFloat share_lat;

+ (NSMutableArray *)test;

@end



//{
//    "share_like_num": 20,
//    "delete_state": "1",
//    "share_category": "0",
//    "user_id": "143218500373424379",
//    "share_create_time": 1435067305000,
//    "sport_ids": "-10086",
//    "share_city": 0,
//    "share_id": 49,
//    "hasLiked": "0",
//    "share_img_path_with_lables": "-10086",
//    "user_nickname": "LF主页君",
//    "share_location": "-10086",
//    "user_logo_img_path": "http://tp3.sinaimg.cn/5634434102/180/5729648148/0",
//    "share_county": 0,
//    "share_paster_ids": "-10086",
//    "share_lon": 118.856552,
//    "share_img_path": [
//                       "http://7xiokh.com1.z0.glb.clouddn.com/3~G1SN{TTWI2AA7P_QZN9KS.jpg"
//                       ],
//    "share_description": "欢迎大家在菜单-反馈里提出建议嗷，主页菌会有小礼品送给热心的小伙伴~",
//    "share_img_path_with_pasters": "-10086",
//    "comment_count": 18,
//    "share_lat": 32.046993
//}
