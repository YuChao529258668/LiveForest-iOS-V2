//
//  YCCycleScrollView.h
//  LiveForest
//
//  Created by 余超 on 15/12/28.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

// cell被点击就发出通知
extern NSString *const YCCycleScrollCellCheckButtonClickNotification;

@interface YCCycleScrollView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) UIPageControl *pageControl;

///是否允许选中cell
@property (nonatomic) BOOL canSelectCell;
@end
