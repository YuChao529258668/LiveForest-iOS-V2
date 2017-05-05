//
//  YCCountDownView.m
//  TestDropdownMenu
//
//  Created by 余超 on 15/12/15.
//  Copyright © 2015年 yc. All rights reserved.
//

#import "YCCountDownView.h"

@interface YCCountDownView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval deadline;
@property (nonatomic, assign) long seconds;

@property (nonatomic, copy) void (^timeOutBlock) ();

@end


@implementation YCCountDownView

#pragma mark - Initial
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
////    _timeOutBlock = block;
////    _deadline = deadline;
////    _seconds = [[NSDate dateWithTimeIntervalSince1970:deadline] timeIntervalSinceNow];
////
////    self = [[NSBundle mainBundle]loadNibNamed:@"YCCountDownView" owner:nil options:nil].lastObject;
////    self.frame = frame;
////
//    [self setupTimer];
//    [self setupDateLabel];
//    return self;
//}
//- (void)awakeFromNib {
//
//}

//+ (instancetype)viewWithFrame:(CGRect)frame countdownSeconds:(long)seconds timeOutBlock:(void (^)())block {
//    return [[self alloc]initWithFrame:frame countdownSeconds:seconds timeOutBlock:block];
//}

//- (instancetype)initWithFrame:(CGRect)frame countdownSeconds:(long)seconds timeOutBlock:(void (^)())block {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _timeOutBlock = block;
//        _seconds = seconds;
//
//        self = [[NSBundle mainBundle]loadNibNamed:@"YCCountDownView" owner:nil options:nil].lastObject;
//        self.frame = frame;
//
//        [self setupTimer];
//        [self setupDateLabel];
//
//    }
//    return self;
//}

+ (instancetype)viewWithFrame:(CGRect)frame deadline:(NSTimeInterval)deadline timeOutBlock:(void (^)())block {
    YCCountDownView *countDownView = [[NSBundle mainBundle]loadNibNamed:@"YCCountDownView" owner:nil options:nil].lastObject;
    countDownView.frame = frame;
    
    countDownView.timeOutBlock = block;
    countDownView.deadline = deadline;
    
    [countDownView setupTimer];
    [countDownView setupDateLabel];
    
    return countDownView;

//    return [[self alloc]initWithFrame:frame deadline:deadline timeOutBlock:block];
}

- (instancetype)initWithFrame:(CGRect)frame deadline:(NSTimeInterval)deadline timeOutBlock:(void (^)())block {
    //方案3
    return [YCCountDownView viewWithFrame:frame deadline:deadline timeOutBlock:block];
    
//    // 方案1
//    self = [[NSBundle mainBundle]loadNibNamed:@"YCCountDownView" owner:nil options:nil].lastObject;
//    _timeOutBlock = block;
//    _deadline = deadline;
//    _seconds = [[NSDate dateWithTimeIntervalSince1970:deadline] timeIntervalSinceNow];
//    self.frame = frame;
//    [self setupTimer];
//    //        [self setupTimerWithDeadline:deadline];
//    [self setupDateLabel];
//    //        [self setupDateLabelWithDeadline:deadline];


    // 方案2
//    self = [super initWithFrame:frame];
//    if (self) {
//        self = [[NSBundle mainBundle]loadNibNamed:@"YCCountDownView" owner:nil options:nil].lastObject;
//
//        _timeOutBlock = block;
//        _deadline = deadline;
//        _seconds = [[NSDate dateWithTimeIntervalSince1970:deadline] timeIntervalSinceNow];
//        
//        self.frame = frame;
//        
//        [self setupTimer];
////        [self setupTimerWithDeadline:deadline];
//        [self setupDateLabel];
////        [self setupDateLabelWithDeadline:deadline];
//        
//    }

//    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
//    return [self initWithFrame:frame countdownSeconds:0 timeOutBlock:nil];
    return [self initWithFrame:frame deadline:0 timeOutBlock:nil];
}

#pragma mark - Life Cycle
- (void)didMoveToSuperview {
    if (self.superview == nil) {
        [self killTimer];
        self.timeOutBlock = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self shiPei];
}

- (void)dealloc {
    HSLog(@"倒计时控件释放 %s",__func__);
}

#pragma mark - Setup
- (void)setupTimer {
    //    HSLog(@"%f",self.deadline);
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(calculate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void)setupDateLabel {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_deadline];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM月dd日 HH:mm";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    _dateLabel.text = dateStr;
}

#pragma mark - Helper
- (void)calculate {
//    NSLog(@"seconds = %ld",seconds);
    self.seconds = [[NSDate dateWithTimeIntervalSince1970:self.deadline] timeIntervalSinceNow];
    if (self.seconds < 0) {
        self.seconds = 0;
    }
    
    int h = (int) _seconds / 3600;
    int m =  (_seconds % 3600 / 60.0);
    int s = _seconds % 3600 % 60;
    
//    HSLog(@"h = %d, m = %d, s = %d",h,m,s);
    
    //    D0021B，红，小于半小时
    //    E0D329，黄，小于一小时
    //    25B36A，绿
    UIColor *color;
    NSString *description;
    if (h > 0) {
        color = [UIColor colorWithRed:0x25/255.0 green:0xB3/255.0 blue:0x6A/255.0 alpha:1];
        description = @"时间充裕，轻松完成挑战！";
    } else if (h == 0 && m >30) {
        color = [UIColor colorWithRed:0xE0/255.0 green:0xD3/255.0 blue:0x29/255.0 alpha:1];
        description = @"时间不多了，抓紧时间完成哦！";
    } else if (h == 0 && m<=30 && s>0){
        color = [UIColor colorWithRed:0xD0/255.0 green:0x02/255.0 blue:0x1B/255.0 alpha:1];
        description = @"时间紧张，争分夺秒！";
    } else if (h == 0 && m == 0 && s <= 0) {
        color = [UIColor darkGrayColor];
        description = @"Time Out ！";
        
        if (self.timeOutBlock) {
            self.timeOutBlock();
        }
        
        [self killTimer];
    }

    [self updateColor:color];
    
    self.hourLable.text = [NSString stringWithFormat:@"%d",h];
    self.minuteLabel.text = [NSString stringWithFormat:@"%d",m];
    self.secondLabel.text = [NSString stringWithFormat:@"%d",s];
    self.describeLabel.text = description;
    
    _seconds --;

}

- (void)updateColor:(UIColor *)color {
//    NSLog(@"%@",self.labels.lastObject);
//    [self.labels performSelector:@selector(setTextColor:) withObject:color];
    for (UILabel *label in self.labels) {
        [label setTextColor:color];
    }
    
    [self.hourLable setTextColor:color];
    [self.minuteLabel setTextColor:color];
    [self.secondLabel setTextColor:color];
    [self.describeLabel setTextColor:color];
}

- (void)killTimer {
    HSLog(@"释放timer %s",__func__);
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/// 缩放containerView
- (void)shiPei {
////    xib是按375的宽度做的，不用缩放
//    if ([UIScreen mainScreen].bounds.size.width == 375) {
//        return;
//    }
    
//    按高度或者宽度较小的缩放，类似ImageView的scaleToFit。
    float scale2 = self.height / _containerView.height;
    float scale3 = self.width / _containerView.width;
    float scale = scale2 < scale3? scale2: scale3;
    
    _containerView.transform = CGAffineTransformScale(_containerView.transform, scale, scale);

    CGPoint center = CGPointMake(self.width / 2, self.height / 2);
    _containerView.center = center;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;   // default returns YES if point is in bounds

//

@end
