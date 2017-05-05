//
//  HSLabelView.h
//  WFAddUIView
//
//  Created by wangfei on 7/11/15.
//  Copyright (c) 2015 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSSportLabelView;
@protocol SportLabelViewDelegate <NSObject>

/**
 *  如果是单选关闭其他选中按钮
 *
 *  @param sportLabelView
 */
- (void)sportLalelViewDidClickButton:(HSSportLabelView *)sportLabelView;

/**
 *  单选直接关闭视图
 *
 *  @param sportLabelVie
 */
- (void)sportLaleViewDidClose:(HSSportLabelView *)sportLabelView;
@end
@interface HSSportLabelView : UIView

@property (nonatomic, strong) NSString* sportID;
@property (nonatomic, strong)UIButton *sportButton;
@property (nonatomic, strong)UILabel *sportLable;

@property (nonatomic, weak) id <SportLabelViewDelegate> delegate;

-(instancetype)initWithIsSingleSelect:(BOOL)isSingleSelection;
@end
