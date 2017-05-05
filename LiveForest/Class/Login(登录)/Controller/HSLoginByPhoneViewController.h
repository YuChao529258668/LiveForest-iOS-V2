//
//  HSLoginByPhoneViewController.h
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSLoginByPhoneViewController : UIViewController<UINavigationControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@end
