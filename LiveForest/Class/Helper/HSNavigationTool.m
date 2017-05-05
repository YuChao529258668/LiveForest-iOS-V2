//
//  HSNavigationTool.m
//  LiveForest
//
//  Created by 余超 on 16/3/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSNavigationTool.h"
#import "HSShareDetailController.h"

@implementation HSNavigationTool

+ (void)pushShareDetailViewControllerWithResourceID:(NSString *)resourceID From:(UIViewController *)fromVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HSShareDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShareDetailController"];

    vc.shareID = resourceID;
    [fromVC.navigationController pushViewController:vc animated:YES];
}

+ (void)pushChallengeDetailViewControllerWithResourceID:(NSString *)resourceID From:(UIViewController *)fromVC {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
//    HSChallengeDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"HSChallengeDetailController"];
//    
//    vc.shareID = resourceID;
//    [fromVC.navigationController pushViewController:vc animated:YES];
}
//
//+ (void)pushChallengeDetailViewControllerWithResource:(id)resource From:(UIViewController *)fromVC {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YueBan" bundle:nil];
//    HSChallengeDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"HSChallengeDetailController"];
//    
//    vc.challengeModel = resource;
//    vc.userStyle = HSChallengeUserStylePlayer;
//    
//    [fromVC.navigationController pushViewController:vc animated:YES];
//}

+ (void)pushChallengeDetailViewControllerWithResource:(id)resource style:(HSChallengeUserStyle)style from:(UIViewController *)fromVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YueBan" bundle:nil];
    HSChallengeDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"HSChallengeDetailController"];
    
    vc.challengeModel = resource;
    vc.userStyle = style;
    
    [fromVC.navigationController pushViewController:vc animated:YES];
}


@end
