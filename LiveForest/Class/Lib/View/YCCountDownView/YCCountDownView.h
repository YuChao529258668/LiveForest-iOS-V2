//
//  YCCountDownView.h
//  TestDropdownMenu
//
//  Created by 余超 on 15/12/15.
//  Copyright © 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCountDownView : UIView
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *clockView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (weak, nonatomic) IBOutlet UILabel *hourLable;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

//+ (instancetype)viewWithFrame:(CGRect)frame countdownSeconds:(long)seconds timeOutBlock:(void (^)())block;

+ (instancetype)viewWithFrame:(CGRect)frame deadline:(NSTimeInterval)deadline timeOutBlock:(void (^)())block;

@end
