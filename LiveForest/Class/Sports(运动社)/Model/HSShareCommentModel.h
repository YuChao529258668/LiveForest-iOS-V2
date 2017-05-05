//
//  HSShareCommentModel.h
//  LiveForest
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

//http://doc.live-forest.com/share/#_24

@interface HSShareCommentModel : NSObject

@property (nonatomic, copy) NSString *comment_id;

@property (nonatomic, copy) NSString *reply_comment_id;

@property (nonatomic, copy) NSString *share_comment_content;

@property (nonatomic, copy) NSString *reply_user_id;

@property (nonatomic, copy) NSString *share_id;

@property (nonatomic, copy) NSString *share_comment_create_time;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *share_comment_like_num;
@property (nonatomic, copy) NSString *user_nickname;

+ (void)getCommentListWithShareID:(NSString *)shareID Success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

@end
