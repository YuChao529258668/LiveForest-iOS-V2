//
//  HSPickView.m
//  LiveForest
//
//  Created by wangfei on 7/3/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//
#define kToobarHeight 40
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
#import "HSPickView.h"
#import "HSDataFormatHandle.h"
@interface HSPickView()<UIPickerViewDataSource,UIPickerViewDelegate>
/**
 *  三级地区选择框
 */
@property (nonatomic, strong)UIPickerView *pickView;
/**
 *  上面保存退出bar
 */
@property (nonatomic, strong)UIView *toolView;
/**
 *  用户选择保存的内容
 */
@property(nonatomic,copy) NSString *resultString;
/**
 *  用户选择地区ID
 */
@property(nonatomic,copy) NSString *areaID;
/**
 *  保存plist整个地区信息
 */
@property(nonatomic,strong) NSDictionary *areaDic;
/**
 *  保存省市区数据
 */
@property(nonatomic,strong) NSMutableArray *provinceArray;
@property(nonatomic,strong) NSMutableArray *cityArray;
@property(nonatomic,strong) NSMutableArray *districtArray;
/**
 *  几级地区选择
 */
@property(nonatomic,assign) AreaLevel areaLevel;

@end
@implementation HSPickView

/**
 *  当前选择的省份信息
 */
static NSString *selectedProvince;

-(instancetype)initWithFrame:(CGRect)frame Level:(AreaLevel)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.areaLevel = type;
        [self addSubview:self.toolView];
        //加载数据
        [self setData];
        
        //设置self的frame,覆盖整个屏幕
        [self setFrame:frame];
        //设置灰色透明
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2];
    }
    return self;
}
/**
 *  从plist中加载数据
 */
-(void)setData
{
    //取出省份的键值
    NSArray *components = [self.areaDic allKeys];
    //排序键值
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    //取出各省份保存到province中
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[self.areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    self.provinceArray = provinceTmp;
    //设置初始值,以后如果是江苏省默认就选择江苏省对应的键值
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [self.provinceArray objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[self.areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    //排序键值
    NSArray *sortedCityArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *arraycityM = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedCityArray count]; i++) {
        NSString *index = [sortedCityArray objectAtIndex:i];
        NSArray *temp = [[dic objectForKey: index] allKeys];
        [arraycityM addObject: [temp objectAtIndex:0]];
    }

    self.cityArray = arraycityM;
    
    /**
     *  如果是三级，加载区域信息
     */
    if (self.areaLevel == AreaLevelDistrict) {
        NSString *selectedCity = [self.cityArray objectAtIndex: 0];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedCityArray objectAtIndex:0]]];
        self.districtArray = [NSMutableArray arrayWithArray:[cityDic objectForKey: selectedCity]];
    }
    
    //设置初始选择行,与上面对应
    [self.pickView selectRow: 0 inComponent: 0 animated: YES];
    
    selectedProvince = [self.provinceArray objectAtIndex:0];
}
-(UIPickerView *)pickView
{
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc]init];
        CGFloat pickViewH = _pickView.bounds.size.height;
        CGFloat pickViewY = self.bounds.size.height - pickViewH;
//        _pickView.frame = CGRectMake(0, pickViewY,_pickView.bounds.size.width,pickViewH);
        _pickView.frame = CGRectMake(0, pickViewY,self.frame.size.width,pickViewH);
        _pickView.dataSource = self;
        _pickView.delegate = self;
        _pickView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickView];
    }
    return _pickView;
}
/**
 *  上面取消和保存选项按钮
 *
 *  @return
 */
-(UIView *)toolView
{
    if (_toolView == nil) {
        CGFloat toolViewH = 44;
        CGFloat toolViewY = self.bounds.size.height - toolViewH - self.pickView.bounds.size.height;
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, toolViewY, self.bounds.size.width, toolViewH)];
        _toolView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        //左右两边按钮
        CGFloat padding = 10;
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(padding, 0, toolViewH, toolViewH)];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(doneClickClose) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:leftButton];
        CGFloat rightButtonX = self.bounds.size.width - padding - toolViewH;
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(rightButtonX, 0, toolViewH, toolViewH)];
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(doneClickSave) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:rightButton];
        
        
        //中间信息描述
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, toolViewH)];
        if (self.areaLevel == AreaLevelCity) {
            label.text = @"常住城市选择";
        }else
        {
            label.text = @"地区选择";
        }
        label.center = CGPointMake(_toolView.bounds.size.width * 0.5,_toolView.bounds.size.height * 0.5);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blueColor];
        [_toolView addSubview:label];
    }
    return _toolView;
}
/**
 *  加载字典信息
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)areaDic
{
    if (_areaDic == nil) {
        NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        _areaDic = [[NSDictionary alloc] initWithContentsOfFile:pathFile];
    }
    return _areaDic;
}
#pragma mark - toolBar按钮点击事件
/**
 *  关闭选项框
 */
-(void)doneClickClose
{
    [self remove];
}
/**
 *  点击保存，通知Controller修改tableView中的值和后台
 *  对于北京北京市---只要传入北京市
 */
-(void)doneClickSave
{
    NSInteger selectProvinceIndex = [self.pickView selectedRowInComponent:PROVINCE_COMPONENT];
    NSInteger selectCityIndex = [self.pickView selectedRowInComponent:CITY_COMPONENT];
    
    NSString *province = [self.provinceArray objectAtIndex:selectProvinceIndex];
    NSString *city = [self.cityArray objectAtIndex:selectCityIndex];
    
//    HSDataFormatHandle *dataFormatHandle = [[HSDataFormatHandle alloc] init];
    if(self.areaLevel == AreaLevelDistrict)
    {
        
        NSInteger selectDistrictIndex = [self.pickView selectedRowInComponent:DISTRICT_COMPONENT];
        NSString *distirct = [self.districtArray objectAtIndex:selectDistrictIndex];
        //对于北京北京市---只要传入北京市
        if ([city rangeOfString:province].length > 0) {
            _selectedProvince = province;
            _selectedCity = city;
            _selectedCounty = distirct;
            self.resultString = [NSString stringWithFormat:@"%@%@",city,distirct];
            self.areaID = [HSDataFormatHandle areaIDFormatHandleWithProvince:province City:city District:distirct];
        }else{
            _selectedProvince = province;
            _selectedCity = city;
            _selectedCounty = distirct;

            self.resultString = [NSString stringWithFormat:@"%@%@%@",province,city,distirct];
            self.areaID = [HSDataFormatHandle areaIDFormatHandleWithProvince:province City:city District:distirct];
        }
    }
    else//2级联动
    {
        //北京省份包含北京市，去除省份信息
        if ([city rangeOfString:province].length > 0) {
            self.resultString = city;
            self.areaID = [HSDataFormatHandle areaIDFormatHandleWithProvince:province City:city District:nil];
            _selectedProvince = province;
            _selectedCity = city;
            _selectedCounty = @"";

        }else{
            self.resultString = [NSString stringWithFormat:@"%@%@",province,city];
            self.areaID = [HSDataFormatHandle areaIDFormatHandleWithProvince:province City:city District:nil];
            _selectedProvince = province;
            _selectedCity = city;
            _selectedCounty = @"";
//            呵呵，学车

        }
    }
    
    //通知tableViewController去修改cell的内容
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:self.resultString forKey:@"areaInfo"];
    if (self.areaID == nil) {//后台数据暂未提供
        self.areaID = @"-10086";//未知
    }
    [dictM setObject:self.areaID forKey:@"areaID"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickSaveCity" object:self userInfo:dictM];
    
    //关闭
    [self remove];
    
}

#pragma mark - pickView数据源方法代理方法
/**
 * 几个选项框
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(self.areaLevel == AreaLevelCity)
    {
        return 2;
    }else{
        return 3;
    }
    
}
/**
 *  每个选项框多少条数据
 *
 *  @param pickerView
 *  @param component
 *
 *  @return 省市区的条数
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [self.provinceArray count];
    }
    else if (component == CITY_COMPONENT) {
        return [self.cityArray count];
    }
    else {
        return [self.districtArray count];
    }

}
/**
 *  设置字体显示格式，用自定义view显示，不要默认的NSString
 *
 *  @param pickerView pickerView
 *  @param row        行
 *  @param component  选项框
 *  @param view
 *
 *  @return 自定义显示视图，不需要设置frame就能显示
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    if (component == PROVINCE_COMPONENT) {
        return [self myViewLabelWithText:self.provinceArray[row]];
    }
    else if(component == CITY_COMPONENT){
        return [self myViewLabelWithText:self.cityArray[row]];
    }
    else{
        return [self myViewLabelWithText:self.districtArray[row]];
    }
    
}
/**
 *  设置自定义地区文字显示格式
 *
 *  @param myView myView 自定义视图
 *  @param text   要显示的地区信息
 *
 *  @return 设置好的视图
 */
-(UILabel *)myViewLabelWithText:(NSString *)text
{
    UILabel *myView = [[UILabel alloc] init];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = text;
    myView.font = [UIFont boldSystemFontOfSize:15.0];
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

#pragma mark - pickView代理方法
/**
 *  选择了哪一个选择（哪个选项框的第几行）触发的动作
 *
 *  @param pickerView
 *  @param row
 *  @param component
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        //当前选择的省份
        selectedProvince = [self.provinceArray objectAtIndex: row];
        //取出目前省份的的信息
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.areaDic objectForKey: [NSString stringWithFormat:@"%ld",row]]];
        //取出对应省份的地级市的信息
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        //排序，按键值大小
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [arrayM addObject: [temp objectAtIndex:0]];
        }
        self.cityArray = arrayM;
        [pickerView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [pickerView reloadComponent: CITY_COMPONENT];

        //是3级地区类型，加载市下一级
        if (self.areaLevel == AreaLevelDistrict) {
            //默认取出第一个(键值0)的市的信息
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            self.districtArray = [NSMutableArray arrayWithArray:[cityDic objectForKey: [arrayM objectAtIndex: 0]]];
            
            [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [pickerView reloadComponent: DISTRICT_COMPONENT];
        }
    }
    else if (component == CITY_COMPONENT && self.areaLevel == AreaLevelDistrict) {
        //取出省份的键值
        NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [self.provinceArray indexOfObject: selectedProvince]];
        //由键值得到省份的信息
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.areaDic objectForKey: provinceIndex]];
        //取出对应省份的地级市的信息
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        //由键值得到对应的市下面的地区信息
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        self.districtArray = [NSMutableArray arrayWithArray:[cityDic objectForKey: [cityKeyArray objectAtIndex: 0]]];
        [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [pickerView reloadComponent: DISTRICT_COMPONENT];
    }

}
#pragma mark - 点击背景关闭
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self remove];
}
#pragma mark - 显示和移除
-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)remove
{
    [self removeFromSuperview];
}
@end
