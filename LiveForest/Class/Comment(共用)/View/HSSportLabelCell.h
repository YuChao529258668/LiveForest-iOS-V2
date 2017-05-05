//
//  HSLableCell.h
//  WFAddUIView
//
//  Created by wangfei on 7/13/15.
//  Copyright (c) 2015 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSportLabelCell : UIView
/**
 *  view的高度
 */
@property (nonatomic,assign) CGFloat viewHeight;

-(instancetype)initWithFrame:(CGRect)frame sportsID:(NSMutableArray *)sportLabels;
@end
