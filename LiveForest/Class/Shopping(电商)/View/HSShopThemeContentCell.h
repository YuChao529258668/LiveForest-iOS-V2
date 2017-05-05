//
//  HSShopThemeContentCell.h
//  LiveForest
//
//  Created by 余超 on 15/12/31.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSGoods;

@interface HSShopThemeContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *falsePriceLabel;

@property (nonatomic, strong) HSGoods *goods;

@end
