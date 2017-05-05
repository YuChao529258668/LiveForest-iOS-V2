//
//  HSPushService.m
//  LiveForest
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSPushService.h"
#import "HSDataFormatHandle.h"
#import "UMessage.h"

@implementation HSPushService

#pragma mark 初始化推送
+(Boolean)initService{

    return YES;
}

+(Boolean)handleUserInfo:(NSDictionary*)userInfo{

    NSString *parent_type = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"parent_type"]];
    NSString *sub_type = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"sub_type"]];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *pushMessage = [aps objectForKey:@"alert"];
    NSLog(@"获取的后台推送消息:%@",pushMessage);
    //关闭友盟对话框
    [UMessage setAutoAlert:NO];
    //    //此方法不要删除
    //    [UMessage didReceiveRemoteNotification:userInfo];
    //
    //    self.userInfo = userInfo;
    //    // app was already in the foreground
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) //应用内进入
    {
        if([parent_type isEqualToString:@"00"]){ //用户模块
            //        if([sub_type isEqualToString:@"00"]){ //好友接收邀请
            //            NSString *user_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //        }else if([sub_type isEqualToString:@"01"]){ //好友关注了我
            //            NSString *user_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }
        }else if([parent_type isEqualToString:@"01"]){//图片分享
            if([sub_type isEqualToString:@"00"]){ //分享被评论
                NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
                
                //                封装数据
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:share_id,@"id",parent_type,@"parent_type",sub_type,@"sub_type",pushMessage,@"pushMessage", nil];
                //点击通知的这一个后，会进入详情
                [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSNotificationDataSource" object:dic];
                
                
            }
            //        else if([sub_type isEqualToString:@"01"]){ //被某个用户在某个分享中 @
            //            NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }
        }else if([parent_type isEqualToString:@"02"]){//约伴
            //todo
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"邀请"
                                                             message:pushMessage
                                                            delegate:self
                                                   cancelButtonTitle:@"查看"
                                                   otherButtonTitles:@"忽略", nil];
            [alert show];
            //        if([sub_type isEqualToString:@"00"]){ //熟人发起的约伴邀请
            //            NSString *yueban_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //        }else if([sub_type isEqualToString:@"01"]){ //你的约伴有人参加了
            //            NSString *yueban_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }
        }else if([parent_type isEqualToString:@"03"]){//线上活动
            //        if([sub_type isEqualToString:@"00"]){ //参与抽奖活动中奖了
            //            NSString *activity_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //        }
        }else if([parent_type isEqualToString:@"04"]){//游戏
            //        if([sub_type isEqualToString:@"00"]){ //被邀请参与某个游戏
            //            NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //        }else if([sub_type isEqualToString:@"01"]){ //用户创建的多人游戏被人参加了
            //            NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }else if([sub_type isEqualToString:@"02"]){ //用户创建的多人游戏被完成了
            //            NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }
        }
        
        
        
    }
    else {  //应用外直接进入
        //        直接进入推送页面
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSInviteFriends" object:pushMessage];
        NSLog(@"邀请按钮发通知啦！");
        //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"邀请"
        //                                                         message:pushMessage
        //                                                        delegate:self
        //                                               cancelButtonTitle:@"查看"
        //                                               otherButtonTitles:@"忽略", nil];
        //        [alert show];
        
    }
    //    UIViewController *vc = [[UIViewController alloc] init];
    //    [vc.view setBackgroundColor:[UIColor blueColor]];
    //    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight/3, kScreenWidth, kScreenHeight*2/3)];
    ////    [alertLabel set];
    //    [alertLabel setText:@"参加活动不,亲？"];
    //    [alertLabel setText:alert];
    //    [alertLabel setTextColor:[UIColor whiteColor]];
    //    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    //    self.window.rootViewController
    //    [s];
    
    return YES;

}

@end
