//
//  HSLableCell.m
//  WFAddUIView
//
//  Created by wangfei on 7/13/15.
//  Copyright (c) 2015 wangfei. All rights reserved.
//

#import "HSSportLabelCell.h"
#import "HSSportModel.h"
#define kCount 4
@interface HSSportLabelCell()
/**
 *  存储用户选取的运动信息描述
 */
@property (nonatomic, strong) NSMutableArray *sportsLabel;
/**
 *  存储用户选取的运动ID
 */
@property (nonatomic, strong) NSMutableArray *sportsID;
/**
 *  存储所有运动信息
 */
@property (nonatomic, strong) NSArray *sportsArray;
@end
@implementation HSSportLabelCell

-(instancetype)initWithFrame:(CGRect)frame sportsID:(NSMutableArray *)sportsID
{
    self = [super initWithFrame:frame];
    if (self) {
        //赋值
        self.sportsID = sportsID;
        
        //添加子空间，9宫格
        CGFloat marginX = 5;
        CGFloat marginY =  15;
        CGFloat subViewW = 60;
        CGFloat subViewH = 22;
        
        for (int i = 0; i < self.sportsLabel.count; i++) {
            //行 0，1，2----0；3，4，5---1
            int row = i/kCount;
            //列 0，3，6，----0; 1, 4, 5---1
            int col = i%kCount;
            
            UILabel *label = [[UILabel alloc]init];
            label.text = self.sportsLabel[i];
            label.textColor = [UIColor colorWithRed:183/255.0 green:220/255.0 blue:123/255.0 alpha:1.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13.0];
            UIColor *color = [UIColor colorWithRed:223/255.0 green:247/255.0 blue:198/255.0 alpha:1.0];
            label.backgroundColor = color;
            //圆角
            label.layer.cornerRadius = 6;
            label.layer.masksToBounds = YES;
            
            //行x的数据主要关系是哪一列 col(从0开始)
            //列y的数据主要关系是哪一行 row（从0开始）
            CGFloat x = col * (marginX + subViewW);
            CGFloat y = row * (marginY + subViewH);
            
            label.frame = CGRectMake(x, y, subViewW, subViewH);
            
            [self addSubview:label];
        }
        _viewHeight = CGRectGetMaxY([self.subviews.lastObject frame]);

    }
    return self;
}

-(NSArray *)sportsArray
{
    if (_sportsArray == nil) {
        _sportsArray = [HSSportModel sportModels];
    }
    return _sportsArray;
}
-(NSMutableArray *)sportsLabel
{
    if (_sportsLabel == nil) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (HSSportModel *model in self.sportsArray) {
            if ([self.sportsID containsObject:model.sportID]) {
                [arrM addObject:model.sportName];
            }
        }
        _sportsLabel = arrM;
    }
    return _sportsLabel;
}
@end
