//
//  HSCreateChallengeController.h
//  LiveForest
//
//  Created by 余超 on 15/12/14.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCDropdownMenu;

@interface HSCreateChallengeController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *friendTF;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UITextField *scoreTF;
@property (weak, nonatomic) IBOutlet UITextField *rewardTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;

@property (nonatomic, strong) YCDropdownMenu *scoreMenu;

@property (weak, nonatomic) IBOutlet UIButton *selectDateBtn;

@end
