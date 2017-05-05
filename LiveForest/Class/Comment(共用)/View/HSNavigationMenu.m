//
//  HSNavigationMenu.m
//  LiveForest
//
//  Created by 余超 on 16/1/19.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSNavigationMenu.h"

@interface HSNavigationMenu ()
@property (weak, nonatomic) IBOutlet UISwitch *uiswitch;
@end

@implementation HSNavigationMenu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HSNavigationMenu" owner:nil options:nil].lastObject;
        self.width = [UIScreen mainScreen].bounds.size.width;
        
        self.triangle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_menu_triangle"]];
        self.triangle.contentMode = UIViewContentModeCenter;
        [self addSubview:self.triangle];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 系统自带的是51，31，设计图36，18
    _uiswitch.transform = CGAffineTransformMakeScale(36/51.0, 36/51.0);
    
    _triangle.y = -_triangle.height;
}

#pragma mark - Actions 
- (IBAction)distanceBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
- (IBAction)dateBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}


@end
