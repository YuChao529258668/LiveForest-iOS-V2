//
//  LiveForestTests.m
//  LiveForestTests
//
//  Created by 余超 on 16/2/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSHttpRequestTool.h"
#import "NSObject+HSJson.h"
#import "HSLocationTool.h"
#import "HSOfficialDisplayPictureActivity.h"
#import "HSUserModel.h"
#import "HSChallengeAttendModel.h"

// HSLog()
#ifdef DEBUG // 处于开发阶段
#define HSLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define HSLog(...)
#endif

//WAIT， waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

// NOTIFY
#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];


@interface LiveForestTests : XCTestCase

@end

@implementation LiveForestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
//    http://doc.live-forest.com/share/#_11
    //    内容／相片／关联的未完成的挑战／位置／好友列表／活动／运动
    NSString *user_token = [HSHttpRequestTool userToken];
    //share_category
    NSArray *share_img_path = @[];
    NSString *share_description = @"";
    //share_city
    //share_county
    //share_lon
    //share_lat
    NSString *share_location = @"南邮";
    NSArray *activity_ids = @[];
    //group_ids
    NSArray *user_ids = @[];
    NSArray *sport_ids = @[];
    NSArray *challenge_ids = @[];
    
    NSMutableDictionary *requestData = @{}.mutableCopy;
    requestData[@"user_token"] = user_token;
    requestData[@"share_img_path"] = share_img_path;
    requestData[@"share_description"] = share_description;
    requestData[@"share_location"] = share_location;
    requestData[@"activity_ids"] = activity_ids;
    requestData[@"user_ids"] = user_ids;
    requestData[@"sport_ids"] = sport_ids;
    requestData[@"challenge_ids"] = challenge_ids;

    NSString *urlstr = @"http://api.liveforest.com/Social/Share/doShareCreateWithAt";
    
    [HSHttpRequestTool GET:urlstr parameters:requestData success:^(id responseObject) {
        HSLog(@"%@",responseObject);
        NOTIFY
    } failure:^(NSString *error) {
        HSLog(@"%s %@",__func__, error);
        NOTIFY
    }];
    WAIT
}

//HSSelectedFriendController
- (void)testGetFriendsList {
    NSString *urlStr = @"http://api.liveforest.com/Social/Following/getFriendsList";
    
    [HSHttpRequestTool GET:urlStr success:^(id responseObject) {
        HSLog(@"%@",[responseObject objectForKey:@"friendsList"]);
        NOTIFY
    } failure:^(NSString *error) {
        HSLog(@"error = %@",error);
        NOTIFY
    }];
    WAIT
}

//HSSelectActivityController
- (void)testGetActivityList {
    //    self.activitys = @[@"吃饭",@"睡觉",@"打豆豆",@"逛街"];
    //  获取所有官方主题晒图活动列表
    NSString *urlStr = @"http://api.yueqiuba.com/Social/Activity/getDisplayPicActivityList";
    
    [HSHttpRequestTool GET:urlStr success:^(id responseObject) {
        HSLog(@"%@",responseObject);
        HSLog(@"%@",[responseObject objectForKey:@"displayPicActivityList"]);
        NOTIFY
    } failure:^(NSString *error) {
        HSLog(@"error = %@",error);
        NOTIFY
    }];
    WAIT
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

- (void)testLocationTool {
    [HSLocationTool startLocation];
    WAIT
}

//- (void)testHSOfficialDisplayPictureActivity {
//    [HSOfficialDisplayPictureActivity getActivityListSuccess:^(NSArray *activitys) {
//        NSLog(@"%@",activitys);
//        NOTIFY
//    } failure:^(NSString *error) {
//        HSLog(@"error = %@",error);
//        NOTIFY
//    }];
//    WAIT
//}

- (void)testUserS {
//    [HSUserModel getUserStatisticsWithUserID:<#(NSString *)#> success:^{
//        <#code#>
//    } failure:^(NSString *error) {
//        <#code#>
//    }];
}

- (void)testChallengeAttend {
    [HSChallengeAttendModel getChallengeAttendsWithChallengeID:@"400" success:^(NSArray *models) {
        HSLog(@"%@", models);
        NOTIFY
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
        NOTIFY
    }];
    WAIT
}
@end
