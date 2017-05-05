//
//  HSAreaTool.m
//  LiveForest
//
//  Created by 余超 on 16/2/28.  wangfei的代码。
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSAreaTool.h"

@interface HSAreaTool ()
@property (nonatomic, strong) NSMutableArray *areaArray;
@end


@implementation HSAreaTool

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

/**
 *  由地区ID获得地区的详细描述，没有中国这一级
 *  市一级--返回 江苏南京市，上海，北京
 *  区一级--放回 江苏南京市鼓楼区，上海闵行区，北京海淀区
 *  @param stringID 后台获得的地区ID
 *
 *  @return 描述
 */
-(NSString *)areaFormatHandleWithStringID:(NSString *)stringID
{
    //stringID---唯一编id,从1开始编码 -10086 不存在
    if (stringID == nil || stringID.length == 0 || [stringID isEqualToString:@"-10086"])
    {
        return nil;
    }
    NSInteger index = [stringID intValue] - 1;
    NSMutableArray *arrayM = self.areaArray;
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
-(NSString *)areaIDFormatHandleWithProvince:(NSString *)province City:(NSString *)city District:(NSString *)district
{
    //市一级--江苏南京市
    if(district == nil)//市一级
    {
        for (NSArray *obj in self.areaArray)
        {
            if ([obj[2] isEqualToString:city]) {
                return obj[0];
                break;
            }
        }
    }
    else//区一级，需要判断父ID是否相等
    {
        for (NSArray *obj in self.areaArray) {
            if ([obj[2] isEqualToString:district]) {
                //判断父id是否相等
                int index = [obj[1] intValue] - 1;
                NSString *fatherArea = self.areaArray[index][2];
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

@end
