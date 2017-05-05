//
//  HSCompletePersonalInfoViewController.h
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCompletePersonalInfoViewController : UIViewController<UITextFieldDelegate>{
    bool datePicked,boyPicked,girlPicked;
    NSString *sexTag;
}
@end
