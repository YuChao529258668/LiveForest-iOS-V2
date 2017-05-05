//
//  HSCommentListController.h
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCommentListController : UIViewController
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, copy) NSString *shareID;

@property (nonatomic, copy) void (^commentSuccessBlock) (NSString *comment);

@end
