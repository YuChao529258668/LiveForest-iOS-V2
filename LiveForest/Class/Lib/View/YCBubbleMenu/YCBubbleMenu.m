//
//  YCBubbleMenu.m
//
//  Created by 余超 on 15/12/13.
//  Copyright © 2015年 yc. All rights reserved.
//

#import "YCBubbleMenu.h"
#import "UIImage+ImageEffects.h"

@interface YCBubbleMenu ()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *blocks;
@property (nonatomic, strong) NSMutableArray *angles;

@property (nonatomic, assign) float radius;

@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UIButton *maskBtn;

@property (nonatomic, assign) BOOL isShow;

@end


@implementation YCBubbleMenu

#pragma mark - Initial
+ (instancetype)menuWithFrame:(CGRect)frame radius:(float)r normalImage:(UIImage *)normal selectedImage:(UIImage *)selected delegate:(id<YCBubbleMenuDelegate>)delegate {
    YCBubbleMenu *menu = [[self alloc]initWithFrame:frame radius:r normalImage:normal selectedImage:selected delegate:delegate];
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame radius:(float)r normalImage:(UIImage *)normal selectedImage:(UIImage *)selected delegate:(id<YCBubbleMenuDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        _delegate = delegate;
        _radius = r;
        _isShow = NO;
        
        _blocks = [NSMutableArray array];
        _buttons = [NSMutableArray array];
        _angles = [NSMutableArray array];
        
        [self setupCenterBtnWithFrame:frame normalImage:normal selectedImage:selected];
        [self setupMaskButton];
    }
    return self;
}

- (void)addButtonWithImage:(NSString *)imageName withAngle:(float)angle clickBlock:(void(^)())block {
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGRect frame = CGRectZero;
    frame.origin = self.frame.origin;
    frame.size   = image.size;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    btn.hidden = YES;
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeCenter;
//    btn.backgroundColor = [UIColor redColor];
//    [btn setImage:image forState:UIControlStateNormal];
    
    [self addButton:btn withAngle:angle clickBlock:block];
}

- (void)addButtonWithTitlte:(NSString *)title Image:(NSString *)imageName withAngle:(float)angle clickBlock:(void(^)())block {
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGRect frame = CGRectZero;
    frame.origin = self.frame.origin;
    frame.size   = image.size;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    btn.hidden = YES;
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeCenter;
//    btn.backgroundColor = [UIColor redColor];
    //    [btn setImage:image forState:UIControlStateNormal];
    
    [self addButton:btn withAngle:angle clickBlock:block];
}

- (void)addButton:(UIButton *)btn withAngle:(float)angle clickBlock:(void(^)())block {
    
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttons addObject:btn];
    [self.angles addObject:@(angle)];
    
    if (block == nil) {
        block = ^{};
    }
    [self.blocks addObject:block];
}

#pragma mark - Setup
- (void)setupCenterBtnWithFrame:(CGRect)frame normalImage:(UIImage *)normal selectedImage:(UIImage *)selected {
    frame.origin = CGPointMake(0, 0);
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setImage:normal forState:UIControlStateNormal];
    [btn setImage:selected forState:UIControlStateSelected];
//    [btn setBackgroundImage:normal forState:UIControlStateNormal];

//    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.imageView.contentMode = UIViewContentModeCenter;
    
    [btn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    self.centerBtn = btn;
//    btn.backgroundColor = [UIColor redColor];
}

- (void)setupMaskButton {
    UIButton *btn = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [btn addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];

    btn.adjustsImageWhenHighlighted = NO;
    btn.alpha = 0;
    self.maskBtn = btn;
}

#pragma mark - Action
- (void)buttonClick:(UIButton *)btn {
    [self hideMenu];
    
    NSUInteger index = [self.buttons indexOfObject:btn];
    void (^block) () = self.blocks[index];
    block();
}

- (void)centerBtnClick:(UIButton *)btn {
    if (self.isShow) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}

- (void)showMenu {
    //设置模糊背景
    UIImage *screenShot = [self screenShot];
    UIImage *blurImage = [screenShot applyBlurWithRadius:10 tintColor:nil saturationDeltaFactor:2 maskImage:nil];
    [self.maskBtn setImage:blurImage forState:UIControlStateNormal];

    //添加子视图到window
    [self addSubviewsToWindow];
    
    self.centerBtn.selected = YES;
    self.isShow = YES;
}

- (void)hideMenu {
    
    [self removeSubviewsFromWindow];
    
    self.centerBtn.selected = NO;
    self.isShow = NO;
}

- (void)addSubviewsToWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window insertSubview:self.maskBtn belowSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskBtn.alpha = 1;
    }];
    
    NSArray *centerPoints = [self centerPointsToWindow];
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *btn = (UIButton *)self.buttons[i];
        
        btn.hidden = NO;
        btn.alpha = 1;
        [window addSubview:btn];

        CGPoint centerPoint;
        NSValue *value = centerPoints[i];
        [value getValue:&centerPoint];
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:0.3 options:0 animations:^{
            btn.center = centerPoint;
        } completion:^(BOOL finished) {
            
        }];
    }


//    self.centerBtn.center = [self.superview convertPoint:self.center toView:nil];
    self.centerBtn.center = [self.superview convertPoint:self.center toView:self.superview];
    [window addSubview:self.centerBtn];
}

- (void)removeSubviewsFromWindow {

    [UIView animateWithDuration:0.2 animations:^{
        self.maskBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskBtn removeFromSuperview];
    }];
    
    //根据角度算位置
    UIButton *btn;
    CGPoint location = self.center;
    for (int i = 0; i < self.buttons.count; i++) {
        btn = (UIButton *)self.buttons[i];
        btn.hidden = NO;
        
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
            btn.center = location;
            btn.alpha = 0.1;
        } completion:^(BOOL finished) {
            btn.hidden = YES;
            [btn removeFromSuperview];
        }];
        
    }

    
    CGRect frame = self.centerBtn.frame;
    frame.origin = CGPointZero;
    self.centerBtn.frame = frame;
    [self addSubview:self.centerBtn];
}

#pragma mark - Helper
- (CGPoint)centerPointWithAngle:(NSNumber *)angleN {
    //坐标转换
//    CGPoint centerPoint = [self.superview convertPoint:self.center toView:nil];
    CGPoint centerPoint = [self.superview convertPoint:self.center toView:self.superview];
    
    //角度转弧度
    float angle = angleN.floatValue;
    float radian = angle * (M_PI / 180);
    
    float x = centerPoint.x - self.radius * cos(radian);
    float y = centerPoint.y - self.radius * sin(radian);
    CGPoint buttonCenterPoint = CGPointMake(x, y);
    
    return buttonCenterPoint;
}

- (NSArray *)centerPointsToWindow {
    NSMutableArray *centers = [NSMutableArray array];
    for (NSNumber *angleN in self.angles) {
        CGPoint center = [self centerPointWithAngle:angleN];
        NSValue *centerV = [NSValue valueWithCGPoint:center];
        [centers addObject:centerV];
    }
    return centers;
}

- (UIImage *)screenShot {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        NSLog(@"%s,window == nil !!!!!",__func__);
        return nil;
    }
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIGraphicsBeginImageContext(bounds.size);
    [window drawViewHierarchyInRect:bounds afterScreenUpdates:NO];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}

- (void)calculate {
    
}

@end
