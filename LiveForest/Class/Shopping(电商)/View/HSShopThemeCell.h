//
//  HSShopThemeCell.h
//  LiveForest
//
//  Created by 余超 on 15/12/7.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSShopTheme;

@interface HSShopThemeCell : UITableViewCell
@property (nonatomic, strong) HSShopTheme *goodsTheme;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descritionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@end
