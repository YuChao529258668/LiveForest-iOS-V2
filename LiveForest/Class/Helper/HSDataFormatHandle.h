//
//  HSDataFormaHandle.h
//  LiveForest
//
//  Created by wangfei on 6/26/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HSDataFormatHandle : NSObject

#pragma mark 定义通用块数据类型
typedef void (^DidRequestBlock)(BOOL *result,id responseData, NSString* err);



/**
 *  将数据中的NSNumber转换成NSString
 *  调用此函数前需对传入的字段进行NSNumber类型判断
 *  @param obj NSNumber
 *
 *  @return string类型
 */
+ (NSString*)handleNumber:(id)obj;
/**
 *  对字典数组中字典各字段检查，将NSNumer字段转换成NSString
 *
 *  @param dictArray 传人的字典数组
 *
 *  @return 处理好的字典数组，可变数组
 */
-(NSMutableArray *)handleDictArray:(NSArray *)dictArray;
/**
 *  将字典中内部的NSNumber转换成NSString
 *
 *  @param dict 传入的字典
 *
 *  @return 处理好的字典，可变字典
 */
-(NSMutableDictionary *)handleDict:(NSDictionary *)dict;

/**
 *  对于后台传入的string日期格式的处理
 *  超过24小时-----M月d日 HH:mm格式
 *  不超过---1小时前，35分钟前， 1分钟前
 *  @param fromNow 英文的时间描述 5 days ago,an hour ago，a few senconds ago,12 hous ago
 *
 *  @return 中文的时间描述
 */
+(NSString *)dateFormaterString:(NSString *)stringDate;

/**
 *  由地区ID获得地区的详细描述，没有中国这一级
 *  市一级--返回 江苏南京市，上海，北京
 *  区一级--放回 江苏南京市鼓楼区，上海闵行区，北京海淀区
 *  @param stringID 后台获得的地区ID
 *
 *  @return 描述
 */
+ (NSString *)areaFormatHandleWithStringID:(NSString *)stringID;

/**
 *  由传入的省市区信息返回地区ID
 *  江苏  南京市 鼓楼区
 *  @param province 省份，没有传入nil
 *  @param city     市
 *  @param district 区，县 不为nil时，前面市必须有信息，否则不能保证唯一性
 *
 *  @return 地区ID
 */
+ (NSString *)areaIDFormatHandleWithProvince:(NSString *)province City:(NSString *)city District:(NSString *)district;


/**
 *  由传入的运动类型ID转换成运动类型
 *
 *  @param stringID 运动类型ID
 *
 *
 *  @return 运动类型
 */
+(NSString *)sportFormatHandleWithSportID:(NSString *)stringID;

#pragma mark 将NSDate获取到的默认时区的时间转化为本地时间
+(NSDate *) toLocalTime:(NSDate*)Date;

+(NSDate *) toGeneralTime:(NSDate*)Date;

#pragma mark 获取今日的时间
+(NSString*)getTodayDate;

/**
 *  将时间戳转化成一个格式的字符日期
 *
 *  @param timestamp 时间戳
 *  @param formater  格式“2001-11-11”--“yyyy-MM-dd”
 *
 *  @return 日期格式
 */
+(NSString *)dateformaterWithTimestamp:(NSString *)timestamp andFormater:(NSString *)formater;
/**
 *  将时间戳转化成年龄
 *  @param stringDate 时间戳
 *
 *  @return 年龄
 */
+(NSString *)getAgeFromBirthday:(NSString *)stringDate;


/**
 *  默认的获取图片方法，并放置在imageview上
 *  @param
 *
 *  @return UIImage
 */
+(void)getImageWithUri:(NSString *)imageUri isYaSuo:(bool)yasuo imageTarget:(UIImageView*) imageTarget defaultImage:(UIImage*)defaultImage andRequestCB:(void (^)(UIImage* image))Callback;
/**
 *@function 直接下载网络图片
 **/
+(void)getImageWithUri:(NSString *)imageUri isYaSuo:(bool)yasuo defaultImage:(UIImage*)defaultImage andRequestCB:(void (^)(UIImage* image))Callback;

+ (NSString*)handleStringWithDefaultValue:(NSString*)target defaultValue:(NSString*)defaultValue;

+ (NSString*)convertSexFromCode:(NSString*)code;

#pragma mark 编码
/*
 url编码
 解决空格问题
 */
+ (NSString*)encodeURL:(NSString*)url;

/**
 *  评论数和点赞数显示格式变换
 * 空，nil---0，>99-----99+
 *  @param stringNumber
 *
 *  @return
 */
+ (NSString *)handleStringNumber:(NSString *)stringNumber;

/**
 *  评论数和点赞数显示格式变换
 * 空，nil---0，>99-----99+
 *  @param stringNumber
 *
 *  @return
 */
#pragma mark 手机号格式判断
+ (BOOL)checkPhoneNumber:(NSString *)str;


#pragma mark - 新版本

/**
 *  给字符串添加中划线
 *
 *  @return 加了中划线的NSMutableAttributedString
 */
+ (NSMutableAttributedString *)addStrikethroughTo:(NSString *)string;

/// yyyy-MM-dd
+ (NSString *)dayString_yyyy_MM_dd:(NSTimeInterval)interval;
/// MM-dd
+ (NSString *)dayString_MM_dd:(NSTimeInterval)interval;
/// 自定义格式
+ (NSString *)dayStringWithDateFormat:(NSString *)format interval:(NSTimeInterval)interval;

@end
