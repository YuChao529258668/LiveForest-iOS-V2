//
//  HSLabelSelectView.h
//  WFAddUIView
//
//  Created by wangfei on 7/11/15.
//  Copyright (c) 2015 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSLabelSelectView : UIView

-(instancetype)initWithSelectedID:(NSMutableArray *)selectedID isSingleSelection:(BOOL)isSingleSelection;
-(void)show;

@end
