//
//  HSDataFormaHandle.m
//  LiveForest
//
//  Created by wangfei on 6/26/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSDataFormatHandle.h"
#import "YLMoment.h"
#import "HSConstantURL.h"
#import "UIImageView+AFNetworking.h" //七牛图片下载
#import "UIImageView+WebCache.h"

@interface HSDataFormatHandle()

@property (nonatomic, strong) NSMutableArray *areaArray;

@end


@implementation HSDataFormatHandle

#pragma mark - 将数据中的NSNumber转换成NSString

/**
 *  将数据中的NSNumber转换成NSString
 *  调用此函数前需对传入的字段进行NSNumber类型判断
 *  @param obj NSNumber
 *
 *  @return string类型
 */
+ (NSString*)handleNumber:(id)obj
{
    if([obj isKindOfClass:[NSNumber class]]){
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        return [numberFormatter stringFromNumber:obj];
    }
    return obj;
}
/**
 *  将字典中内部的NSNumber转换成NSString
 *
 *  @param dict 传入的字典
 *
 *  @return 处理好的字典，可变字典
 */
-(NSMutableDictionary *)handleDict:(NSDictionary *)dict
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
    //遍历字典，将内部中NSNumber转换成NSString
    [dictM enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSString *stringValue = [HSDataFormatHandle handleNumber:obj];
            [dictM setObject:stringValue forKey:key];
        }
    }];
    return dictM;
}
/**
 *  对字典数组中字典各字段检查，将NSNumer字段转换成NSString
 *
 *  @param dictArray 传人的字典数组
 *
 *  @return 处理好的字典数组，可变数组
 */
-(NSMutableArray *)handleDictArray:(NSArray *)dictArray
{
    NSMutableArray *dictArrayM = [NSMutableArray arrayWithArray:dictArray];
    for (int i = 0; i < [dictArrayM count]; i++)
    {
        //未完成对嵌套数组的查找转换
        NSMutableDictionary *dictM = [self handleDict:dictArray[i]];
        //替换数组对应的字典
        [dictArrayM replaceObjectAtIndex:i withObject:dictM];
    }
    return dictArrayM;
}

#pragma mark - Date Helper

#pragma mark 将某个时间转化为本地时间
+(NSDate *) toLocalTime:(NSDate*)Date
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: Date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: Date];
}

#pragma mark 将某个时间转化为标准时间
+(NSDate *) toGeneralTime:(NSDate*)Date
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: Date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: Date];
}

#pragma mark 判断两个时间是否在同一天

#pragma mark 获取今日的日期，譬如 2014-9-18
+(NSString*)getTodayDate{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //返回今日时间的数据
    return currentDateStr;
    
}


/**
 *  将时间戳转化成中文
 *  超过24小时-----M月d日 HH:mm格式
 *  不超过---1小时前，35分钟前， 1分钟前
 *  @param stringDate 时间戳
 *
 *  @return 时间描述
 */
+(NSString *)dateFormaterString:(NSString *)stringDate
{
    //为空判断
    if([stringDate isEqualToString:@""] || [stringDate isEqualToString:@"-10086"] || !stringDate){
        return @"未知时间";
    }
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:([stringDate integerValue]/1000)];
    YLMoment *moment = [[YLMoment alloc] initWithDate:time];
    NSString *fromNow = [moment fromNow];
    
    if ([fromNow rangeOfString:@"years"].length>0||[fromNow rangeOfString:@"months"].length>0||[fromNow rangeOfString:@"days"].length>0||[fromNow rangeOfString:@"day"].length>0)
    {
        //不属于今天
        fromNow = [moment format:@"M月d日 HH:mm"];
        
    }
    else//对于一天当中，具体情况的处理 an hour ago
    {
        NSArray *temArray = [fromNow componentsSeparatedByString:@" "];
        
        if([fromNow rangeOfString:@"hours"].length > 0||[fromNow rangeOfString:@"hour"].length > 0)
        {
            
            if ([temArray[0] isEqualToString:@"an"]) {
                fromNow = @"1小时前";
            }else{
                fromNow = [NSString stringWithFormat:@"%@小时前",temArray[0]];
            }
        }
        else//秒统一处理成一分钟前、分钟 a few seconds ago
        {
            if ([temArray[0] isEqualToString:@"a"]) {
                fromNow = @"1分钟前";
            }else{
                fromNow = [NSString stringWithFormat:@"%@分钟前",temArray[0]];
            }
        }
        
    }
    
    return fromNow;
}
/**
 *  将时间戳转化成一个格式的字符日期
 *
 *  @param timestamp 时间戳
 *  @param formater  格式“2001-11-11”--“yyyy-MM-dd”
 *
 *  @return 日期格式
 */
+(NSString *)dateformaterWithTimestamp:(NSString *)timestamp andFormater:(NSString *)formater
{
    //为空判断
    if(timestamp == nil || timestamp.length == 0 || [timestamp isEqualToString:@"-10086"]){
        return @"-10086";//未知
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timestamp integerValue]/1000)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formater];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}


/**
 *  由传入的运动类型ID转换成运动类型
 *
 *  @param stringID 运动类型ID
 *
 *
 *  @return 运动类型
 */
+(NSString *)sportFormatHandleWithSportID:(NSString *)stringID{

    int  num = [stringID intValue];
   
    if ((num < 4)|| (num > 23)) {
        return @" ";
    }
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"sport.plist" ofType:nil]];

    NSString *str = [NSString string];
    NSString *idToCompare =[NSString stringWithFormat:@"%d",num];
    for (NSDictionary * dict in array) {
        if ([[dict objectForKey:@"sportID"]isEqualToString:idToCompare]) {
            str = [dict objectForKey:@"sportName"];
            return str;
        }
    }
    return str;
}

//+ (NSArray *)


/**
 *  将时间戳转化成年龄
  *  @param stringDate 时间戳
 *
 *  @return 年龄
 */
+(NSString *)getAgeFromBirthday:(NSString *)stringDate
{
    //为空判断
    if (![stringDate isKindOfClass:[NSString class]]) {
        return @"未知年龄";
    }
    if([stringDate isEqualToString:@""] || [stringDate isEqualToString:@"-10086"] || !stringDate){
        return @"未知年龄";
    }
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:([stringDate integerValue]/1000)];
    
    NSTimeInterval dateDiff = [time timeIntervalSinceNow];
    
    int age=trunc(dateDiff/(60*60*24))/365;
    
    if(age<0){
        age = - age;
    }
    
    return [NSString stringWithFormat:@"%i",age];
    
   
}

/*
 对imageview赋值
 返回的image是为了让视图立即呈现；
 imagetarget
 */
#pragma mark 统一的根据URL获取头像资源，并放置在uiimageview上
+(void)getImageWithUri:(NSString *)imageUri isYaSuo:(bool)yasuo imageTarget:(UIImageView*) imageTarget defaultImage:(UIImage*)defaultImage andRequestCB:(void (^)(UIImage* image))Callback{
    
    //首先设置imageview的默认图片
    imageTarget.image = defaultImage;
    
    //如果图片格式为空或者存在问题
    if (imageUri == nil || imageUri.length == 0 || [imageUri isEqualToString:@"-10086"]) {
        
        return Callback(defaultImage);
        
    //判断图片是否在本地缓存中
    }else{
        //格式化图片路径
        NSString *avatarUrl = [[NSString alloc]initWithString:imageUri];
        
        //压缩图片路径
        if(yasuo){
            avatarUrl = [[NSString alloc] initWithFormat:@"%@%s",avatarUrl ,QiNiuImageYaSuo];
        }
        
        //编码图片路径
        NSURL * urlAvarl = [NSURL URLWithString:[self encodeURL:avatarUrl]];
        
        
        
        //修复URL含有中文转换后为nil的问题
        if (urlAvarl == nil) {
//            urlAvarl  = [NSURL url]
            avatarUrl = [avatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            urlAvarl = [NSURL URLWithString:avatarUrl];
        }
        
        
        
        //异步
        //1.获得全局的并发队列
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_async(queue, ^{
            if(imageTarget){
                [imageTarget sd_setImageWithURL:urlAvarl
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if(image){
                                              imageTarget.image = image;
                                              
                                              //调用回调函数
                                              if(Callback){
                                                  return Callback(image);
                                              }
                                              
                                          }
                                          else{
                                              NSLog(@"网络获取图像失败：%@",error);
                                          }
                                      }];
            }
            else{
                NSLog(@"targetiamge 为空");
                return Callback(defaultImage);
            }
            
        });
        
    }
}

#pragma mark 没有封装sd_setImageWithURL方法
/**
 *@function 直接下载网络图片
 **/
+(void)getImageWithUri:(NSString *)imageUri isYaSuo:(bool)yasuo defaultImage:(UIImage*)defaultImage andRequestCB:(void (^)(UIImage* image))Callback{
    
    //如果图片格式为空或者存在问题
    if (imageUri == nil || imageUri.length == 0 || [imageUri isEqualToString:@"-10086"]) {
        return Callback(defaultImage);;
        
        //判断图片是否在本地缓存中
    }else if([imageUri isEqualToString: @"locateImage"]){
        //获取本地缓存图片
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        return Callback([UIImage imageWithData:[userDefaults objectForKey:imageUri]]);
    }else{
        
        //压缩图片路径
        if(yasuo){
            imageUri = [[NSString alloc] initWithFormat:@"%@%s",imageUri ,QiNiuImageYaSuo];
        }
        
        //编码图片路径
        imageUri = [self encodeURL:imageUri];
        
        //否则则发起网络请求
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:imageUri] options:0
        //图片处理
        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             
         }
        //完成的回调事件
        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 return Callback(image);
             }
             else{
                 return Callback(defaultImage);
             }
         }];
    }

}

#pragma mark 判断字符串是否为空或者无效，并且赋予其默认的值
+ (NSString*)handleStringWithDefaultValue:(NSString*)target defaultValue:(NSString*)defaultValue {
    
    if(target == nil || target.length == 0 || [target isEqualToString:@"-10086"]){
        return defaultValue;
    }else{
        return target;
    }

}

#pragma mark 将用户的性别编码转化为具体的描述
+ (NSString*)convertSexFromCode:(NSString*)code {
    if([code isEqualToString:@"0"]){
        return @"男";
    }else if([code isEqualToString:@"1"]){
        return @"女";
    }
    else{
        return @"未知";
    }
}

#pragma mark 编码
+ (NSString*)encodeURL:(NSString*)url{
//    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange _range = [url rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
//        NSString *tmp = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        return tmp;
        return  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else {
        //没有空格，直接解析
        return url;
    }
}
/**
 *  评论数和点赞数显示格式变换
 * 空，nil---0，>99-----99+
 *  @param stringNumber
 *
 *  @return
 */
+ (NSString *)handleStringNumber:(NSString *)stringNumber
{
    //空返回0
    if (stringNumber == nil || stringNumber.length == 0) {
        return @"0";
    }
    
    //>99 返回99+
    if (stringNumber.length > 2) {
        stringNumber = @"99+";
    }
    return stringNumber;
}


/**
 *  评论数和点赞数显示格式变换
 * 空，nil---0，>99-----99+
 *  @param stringNumber
 *
 *  @return
 */
#pragma mark 手机号格式判断
+ (BOOL)checkPhoneNumber:(NSString *)str

{
    
    if ([str length] == 0) {
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
//    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString *regex = @"^1+[34578]+\\d{9}";
//    var regex = {
//    mobile: /^0?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$/
//    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark - 地区和编码的转换

/**
 *  由地区ID获得地区的详细描述，没有中国这一级
 *  市一级--返回 江苏南京市，上海，北京
 *  区一级--放回 江苏南京市鼓楼区，上海闵行区，北京海淀区
 *  @param stringID 后台获得的地区ID
 *
 *  @return 描述
 */
+ (NSString *)areaFormatHandleWithStringID:(NSString *)stringID
{
    HSDataFormatHandle *dfh = [HSDataFormatHandle new];
    
    //stringID---唯一编id, 从1开始编码 -10086 不存在
    if (stringID == nil || stringID.length == 0 || [stringID isEqualToString:@"-10086"])
    {
        return nil;
    }
    NSInteger index = [stringID intValue] - 1;
    NSMutableArray *arrayM = dfh.areaArray;
    //取出当前数据信息
    NSArray *obj = arrayM[index];
    NSInteger fatherID = [obj[1] intValue];
    //父一级ID不是中国，中国省略
    //返回格式：江苏南京市玄武区  江苏南京市
    //北京北京市朝阳区  北京市
    
    if(fatherID > 1 && fatherID < [arrayM count])   //父ID不是0，1
    {
        //取出父信息
        NSArray *fatherArray = arrayM[fatherID -1];
        //取出父信息的父ID
        NSInteger fatherID = [fatherArray[1] intValue];
        NSString *fatherName = fatherArray[2];//父一级名称
        if (fatherID != 1)
        {
            NSArray *faArray = arrayM[fatherID - 1];
            NSString *faName = faArray[2];
            //三级 江苏南京市玄武区 北京北京市玄武区
            //处理自治县，市，比如东莞市下面也是东莞市
            if ([obj[2] isEqualToString:fatherName]) {
                return [NSString stringWithFormat:@"%@%@",faName,obj[2]];
            }
            //北京北京市玄武区-- 北京市玄武区
            if ([fatherName rangeOfString:faName].length > 0)
            {
                return [NSString stringWithFormat:@"%@%@",fatherName,obj[2]];
            }
            return [NSString stringWithFormat:@"%@%@%@",faName,fatherName,obj[2]];
        }
        else
        {
            //北京市 江苏南京市
            //北京北京市----处理成北京市
            if([obj[2] rangeOfString:fatherName].length > 0)
            {
                return [NSString stringWithFormat:@"%@",obj[2]];
            }
            return [NSString stringWithFormat:@"%@%@",fatherName,obj[2]];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%@",obj[2]];//省一级，或者中国
    }
    
}
/**
 *  由传入的省市区信息返回地区ID
 *  江苏  南京市 鼓楼区
 *  @param province 省份，没有传入nil
 *  @param city     市
 *  @param district 区，县 不为nil时，前面市必须有信息，否则不能保证唯一性
 *
 *  @return 地区ID
 */
+ (NSString *)areaIDFormatHandleWithProvince:(NSString *)province City:(NSString *)city District:(NSString *)district
{
    HSDataFormatHandle *dfh = [HSDataFormatHandle new];
    
    //市一级--江苏南京市
    if(district == nil)//市一级
    {
        for (NSArray *obj in dfh.areaArray)
        {
            if ([obj[2] isEqualToString:city]) {
                return obj[0];
                break;
            }
        }
    }
    else//区一级，需要判断父ID是否相等
    {
        for (NSArray *obj in dfh.areaArray) {
            if ([obj[2] isEqualToString:district]) {
                //判断父id是否相等
                int index = [obj[1] intValue] - 1;
                NSString *fatherArea = dfh.areaArray[index][2];
                if([city isEqualToString:fatherArea])
                {
                    return obj[0];
                    break;
                }
            }
        }
    }
    
    return nil;
}

/**
 *  地区转换数据加载，csv文件
 *  1,0,中国,,,
 *  2,1,江苏省,,,
 *  3,2,南京市,,,
 *  4,3,玄武区,,,
 *  前三个必须有:id，父id，名称
 *  @return 数组中包含数组
 */
-(NSMutableArray *)areaArray
{
    if (_areaArray == nil)
    {
        //获取csv文件路径
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *txtPath = [mainBundle pathForResource:@"t_area" ofType:@"csv"];
        // 将csv到string对象中，编码类型为NSUTF8StringEncoding
        NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *areaArray = [string componentsSeparatedByString:@"\n"];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSString *obj in areaArray) {
            NSArray *eachArray = [obj componentsSeparatedByString:@","];
            [arrayM addObject:eachArray];
        }
        _areaArray = arrayM;
    }
    return _areaArray;
}

#pragma mark - 新版本

// 添加中划线
+ (NSMutableAttributedString *)addStrikethroughTo:(NSString *)string {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(NSUnderlineStyleSingle), NSStrikethroughStyleAttributeName, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], NSStrikethroughColorAttributeName, nil];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:string attributes:attributes];
    return as;
}

/// yyyy-MM-dd
+ (NSString *)dayString_yyyy_MM_dd:(NSTimeInterval)interval {
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
//    NSLog(@"%lf",[NSDate date].timeIntervalSince1970);
//    NSLog(@"%lf",interval);
    return [df stringFromDate:date];
}

/// MM-dd
+ (NSString *)dayString_MM_dd:(NSTimeInterval)interval {
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970];
    return [df stringFromDate:date];
}

+ (NSString *)dayStringWithDateFormat:(NSString *)format interval:(NSTimeInterval)interval {
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = format;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970];
    return [df stringFromDate:date];
}


@end
