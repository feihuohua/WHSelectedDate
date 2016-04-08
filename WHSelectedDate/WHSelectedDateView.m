//
//  WHSelectedDateView.m
//  WHSelectedDate
//
//  Created by houjing on 16/4/6.
//  Copyright © 2016年 eresl. All rights reserved.
//

#import "WHSelectedDateView.h"


#define AllDateNum  365

@interface WHSelectedDateView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;//选择器
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;//确定按钮

@property (nonatomic, retain) UIControl *controlForDismiss;                     //没有按钮的时候，



@property (nonatomic, strong) NSMutableArray *pickerDate;//日期
@property (nonatomic, strong) NSMutableArray *pickerHour;//小时
@property (nonatomic, strong) NSMutableArray *pickerMinute;//分钟

@property (nonatomic, strong) NSString *myDate;//选择的时间

@property (nonatomic, strong) NSString *dateStr;//日期
@property (nonatomic, strong) NSString *hourStr;//小时
@property (nonatomic, strong) NSString *minuteStr;//分钟










//取消按钮被点击
- (IBAction)cancelBtnClicked:(id)sender;
//确认按钮被点击
- (IBAction)confirmBtnClicked:(id)sender;

//动画进入
- (void)animatedIn;

//动画消失
- (void)animatedOut;

@end

@implementation WHSelectedDateView

//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
//    
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"WHSelectedDateView" owner:self options:nil];
//        WHSelectedDateView *view = [nibs lastObject];
//        
//        self = view;
//    }
//    
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"WHSelectedDateView" owner:self options:nil];
        self = [nibs lastObject];
        
        //设置默认值: 7天
        self.dateLimitNum = 7;
        
        //设置默认值: 24小时
        self.hoursType = UIHoursTypeAll;
        
        //设置默认值: 60分钟
        self.minutesType = UIMinutesTypeAll;
        
        // 显示选中框
        self.pickView.showsSelectionIndicator=YES;
        self.pickView.dataSource = self;
        self.pickView.delegate = self;
        
        
    }
    
    return self;
}

#pragma mark - set
//设置标题
- (void)setTitleString:(NSString *)titleString{
    
    _titleString = titleString;
    
    if (_titleString) {
        _titleLabel.text = _titleString;
    }
}

////天数
//- (void)setDateType:(UIDateType)dateType{
//    
//    _dateType = dateType;
//    //设置数组天数
//    
//}

//小时
- (void)setHoursType:(UIHoursType)hoursType{
    
    _hoursType = hoursType;
    //设置小时数组
    [self updatePickerHour];
}

//分钟
- (void)setMinutesType:(UIMinutesType)minutesType{
    
    _minutesType = minutesType;
    //设置分钟数组
    [self updatePickerMinute];
}

//限制显示天数
- (void)setDateLimitNum:(NSInteger)dateLimitNum{
    
    _dateLimitNum = dateLimitNum;
    //设置数组天数
    [self updatePickerDate];
}

//- (void)setDelegate:(id<WHSelectedDateViewDelegate>)delegate{
//    
//    if (delegate) {
//        _delegate = delegate;
//    }
//}

#pragma mark - 获取选中的小时的下标
- (int )getHourStrIndex{
    int index = 0;
    for (int j = 0; j < _pickerHour.count; j++) {
        if ([_hourStr intValue] == [_pickerHour[j] intValue]) {
            index = j;
            break;
        }
    }
    
    return index;
}

#pragma mark - update
//设置日期数组
- (void)updatePickerDate{
    
    _pickerDate = [NSMutableArray array];
    
    if (_dateLimitNum == 0) {
        
        _dateLimitNum = AllDateNum;
    }
    
    for (int i = 0; i < _dateLimitNum; i ++) {
        NSDate *day = [NSDate dateWithTimeIntervalSinceNow:+(24*60*60)*i];
        NSDateFormatter  *dateformat=[[NSDateFormatter alloc] init];
        [dateformat setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *  loString=[dateformat stringFromDate:day];
        [_pickerDate addObject:loString];
    }
    
    self.dateStr = _pickerDate[0];
    NSLog(@"_pickerDate:%@",_pickerDate);
}

//设置小时数组
- (void)updatePickerHour{
    
    _pickerHour = [NSMutableArray array];
    
    //工作时间
    if (_hoursType == UIHoursTypeWork) {
        _pickerHour=[NSMutableArray arrayWithObjects:@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18", nil];
//        _pickerHour=[NSMutableArray arrayWithObjects:@"08",@"09",@"10",@"11", nil];
    }
    else{
        // 默认值为  UIHoursTypeAll
        _pickerHour=[NSMutableArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    }
    
    //获取之前的下标,以便变动时，知道当前小时数应该被修改为数组中的哪一个下标对应的小时数
    int index = [self getHourStrIndex];
    
    self.hourStr = _pickerHour[index];
    
    NSLog(@"pickerHour:%@",_pickerHour);
}

//设置分钟数组
- (void)updatePickerMinute{
    
    _pickerMinute = [NSMutableArray array];
    
    if (self.minutesType == UIMinutesTypeHalfHour){
        _pickerMinute = [NSMutableArray arrayWithObjects:@"00",@"30", nil];
    }else if (self.minutesType == UIMinutesTypeQuarterHour){
        _pickerMinute = [NSMutableArray arrayWithObjects:@"00",@"15",@"30",@"45", nil];
    }
    else{
        //默认值为   UIMinuteTypeAll
        [_pickerMinute removeAllObjects];
        for (int i = 0; i < 6; i++) {
            for (int j= 0; j < 10; j++) {
                NSString *minute = [NSString stringWithFormat:@"%li%li", (long)i, (long)j];
                
                [_pickerMinute addObject:minute];
            }
        }
    }
    
    self.minuteStr = _pickerMinute[0];
    
    NSLog(@"pickerMinute:%@",_pickerMinute);
}


#pragma mark - next  是否需要从下一个时段算起
//判断打开界面的时间是否是下班时间
- (BOOL)isStartFromNextDate{
    
    NSString *datestr = [NSString stringWithFormat:@"%@ %@:%@", (NSString *)self.pickerDate[0], (NSString *)[self.pickerHour lastObject] ,(NSString *)[self.pickerMinute lastObject]];
    NSLog(@"datestr:%@",datestr);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    //[dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    NSDate *lastTimeInDate = [dateFormatter dateFromString:datestr];
    NSLog(@"lastTimeInDate:%@",lastTimeInDate);
    
    if ([lastTimeInDate isEqualToDate:[lastTimeInDate earlierDate:[NSDate date]]]) {
        NSLog(@"earlierDate  = %@",[lastTimeInDate earlierDate:[NSDate date]]);
        return YES;
    }
    return NO;
    
}

////判断是否需要从下一个小时显示
//- (BOOL)isStartFromNextHour{
//    
//    //是今天
//    if ([self judgeSeledtedDateIsToday]) {
//        //是当前小时
//        if ([self judgeSeledtedHourIsNowHour]) {
//            //当前时间的分钟数大于或等于分钟数组中的最后一个分钟数
//            if ([self judgeNowMinuteIsLargeTheLastMinute]) {
//                return YES;
//            }
//        }
//    }
//    
//    return NO;
//}

//判断是不是选择的今天
- (BOOL)judgeSeledtedDateIsToday{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"nowDateStr:%@",nowDateStr);
    if ([_dateStr isEqualToString:nowDateStr]) {
        return YES;
    }else{
        return NO;
    }
}

//判断选择的小时数是不是当前小时数
- (BOOL)judgeSeledtedHourIsNowHour{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    NSString *nowHourStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"nowHourStr:%@",nowHourStr);
    NSLog(@"_hourStr:%@",_hourStr);
    if ([_hourStr isEqualToString:nowHourStr]) {
        return YES;
    }else{
        return NO;
    }
}


//获取一个完整的分钟数组
- (NSMutableArray *)getAllMinutesArray{
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.minutesType == UIMinutesTypeHalfHour){
        array = [NSMutableArray arrayWithObjects:@"00",@"30", nil];
    }else if (self.minutesType == UIMinutesTypeQuarterHour){
        array = [NSMutableArray arrayWithObjects:@"00",@"15",@"30",@"45", nil];
    }
    else{
        //默认值为   UIMinuteTypeAll
        for (int i = 0; i < 6; i++) {
            for (int j= 0; j < 10; j++) {
                NSString *minute = [NSString stringWithFormat:@"%li%li", (long)i, (long)j];
                
                [array addObject:minute];
            }
        }
    }
    
    return array;
}

//判断选择的分钟数是不是大于当前分钟数
- (BOOL)judgeNowMinuteIsLargeTheLastMinute{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    NSString *nowMinuteStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"nowMinuteStr:%@",nowMinuteStr);
    NSLog(@"lastObject:%@",[_pickerMinute lastObject]);
    
    //是18点，此时分钟只有00，作出的判断不准确,不是18点就是准确的
    if ([self isWorkTimeAndHourStrIs18]) {
        //获取完整的分钟数组
       NSMutableArray *array = [self getAllMinutesArray];
        
        if ([nowMinuteStr intValue] >= [[array lastObject] intValue] ) {
            return YES;
        }else{
            return NO;
        }
        
        
    }else{
        
        if ([nowMinuteStr intValue] >= [[_pickerMinute lastObject] intValue] ) {
            return YES;
        }else{
            return NO;
        }
    }
    
}

#pragma mark - change
//进入界面就判断是否是否从第二天开始，更换数组
- (void)initPickerDateAndHourAndMinute{
    
    if ([self isStartFromNextDate]) {
        //天数数组删除本天的
        [_pickerDate removeObjectAtIndex:0];
        
        //天数数组增加第八天的
        NSDate *day = [NSDate dateWithTimeIntervalSinceNow:+(24*60*60)*_dateLimitNum+1];
        NSDateFormatter  *dateformat=[[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *  loString=[dateformat stringFromDate:day];
        [_pickerDate addObject:loString];
        
        //选中日期变更
        _dateStr = self.pickerDate[0];
        
        //还原小时数组
        [self updatePickerHour];
        //还原分钟数组
        [self updatePickerMinute];
        
    }else{
        
        //处理初始化的小时数组和分钟数组
        [self changePickerDate];
        
    }
}

//根据选择的是否是今天，对小时和分钟数组进行处理
- (void)changePickerDate{
    
    //是今天
    if ([self judgeSeledtedDateIsToday]) {
        
        //改变小时数组和分钟数组
        [self changePickeHour];
        
    }else{
        
        int index = [self getHourStrIndex];
        
        //还原小时数组
        [self updatePickerHour];
        
        _hourStr = _pickerHour[index];
        
        // 检查是否是工作时间的18点，是：就修改分钟数组只显示00，否：就还原分钟数组
        [self is18EndWorkToChangePickerMinute];
    }
    
}

- (void)changePickeHour{
    
    //删除今天已过去的小时
    
    //小时数组删除小于当前小时数的元素
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    NSString *nowHourStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"nowHourStr:%@",nowHourStr);
    NSLog(@"_hourStr:%@",_hourStr);
    
    //获取之前的下标,以便变动时，知道当前小时数应该被修改为数组中的哪一个下标对应的小时数
    int index = [self getHourStrIndex];
    
    
    int count = (int)_pickerHour.count - 1;
    
    for (int i = count; i >= 0; i--) {
        if ([_pickerHour[i] intValue] < [nowHourStr intValue]) {
            [_pickerHour removeObjectAtIndex:i];
        }
    }
    NSLog(@"index:%zd",index);
    NSLog(@"_pickerHour.count:%zd",_pickerHour.count);
    //如果选择的小时数，比删除元素后的小时数组的第一个还小，就表明要修改为当前数组对应下标的小时数
    if ([_hourStr intValue] < [_pickerHour[0] intValue]) {
        if (index >= _pickerHour.count) {
            _hourStr = [_pickerHour lastObject];
        }else{
            NSLog(@"index:%zd",index);
            _hourStr = _pickerHour[index];
        }
        
    }
    
    //如果当前修改的时间不是今天工作时间的结束时间了，就要还原分钟数组
    if (![self isWorkTimeAndHourStrIs18]) {
        
        //还原分钟数组
        [self updatePickerMinute];
    }
//    [self is18EndWorkToChangePickerMinute];
    
    //数组中的当前小时数是否是需要删除
    if ([self isNeedToRemoveTheNowHourFormPickerHour]) {
        
        [_pickerHour removeObjectAtIndex:0];
        
        NSLog(@"_hourStr:%@",_hourStr);
        //如果选择的小时数，比删除元素后的小时数组的第一个还小，就表明要修改为当前数组对应下标的小时数
        if ([_hourStr intValue] <= [_pickerHour[0] intValue]) {
            if (index >= _pickerHour.count) {
                _hourStr = [_pickerHour lastObject];
            }else{
                _hourStr = _pickerHour[index];
            }
            
        }else{
            NSLog(@"_hourStr:%@",_hourStr);
        }
        NSLog(@"_hourStr:%@",_hourStr);
        // 检查是否是工作时间的18点，是：就修改分钟数组只显示00，否：就还原分钟数组
        [self is18EndWorkToChangePickerMinute];
        
    }else{
        //如果下标大于新的_pickerHour的数量，需要将_hourStr做修改
        if (index >= _pickerHour.count) {
            _hourStr = [_pickerHour lastObject];
        }else{
            _hourStr = _pickerHour[index];
        }
        
        //如果选择的小时数为当前小时数，才删除，否则还原
        if ([self judgeSeledtedHourIsNowHour]) {
            
            //删除已过的分钟数组
            [self changePickerMinute];
        }else{
            
            // 检查是否是工作时间的18点，是：就修改分钟数组只显示00，否：就还原分钟数组
            [self is18EndWorkToChangePickerMinute];
            
        }
    }
}

//- (void)changePickeHour{
//
//    //删除今天已过去的小时
//    
//    //小时数组删除小于当前小时数的元素
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH"];
//    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
//    NSString *nowHourStr = [dateFormatter stringFromDate:[NSDate date]];
//    NSLog(@"nowHourStr:%@",nowHourStr);
//    
//    int count = (int)_pickerHour.count - 1;
//    
//    for (int i = count; i >= 0; i--) {
//        if ([_pickerHour[i] intValue] < [nowHourStr intValue]) {
//            [_pickerHour removeObjectAtIndex:i];
//        }
//    }
//    
//    if ([self isStartFromNextHour]) {
//        
//        [_pickerHour removeObjectAtIndex:0];
//        
//        //还原分钟数组
//        [self updatePickerMinute];
//        
//    }else{
//        //改变分钟数组
//        [self changePickerMinute];
//    }
//}

- (void)changePickerMinute{
    
    //分钟数组删除小于当前分钟数的元素
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    NSString *nowHourStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"nowHourStr:%@",nowHourStr);
    
    int count = (int)_pickerMinute.count - 1;
    
    for (int i = count; i >= 0; i--) {
        if ([_pickerMinute[i] intValue] < [nowHourStr intValue]) {
            [_pickerMinute removeObjectAtIndex:i];
        }
    }
}

#pragma mark - 删除时间数组中的当前时间对应的值
- (BOOL )isNeedToRemoveTheNowHourFormPickerHour{
    
    //是今天，且小时数组中的第一个元素与当前小时数相等，当前分钟数比分钟数组中最后一个分钟数还要大
    if ([self judgeSeledtedDateIsToday]) {
        if ([self isPickerHour0IsEqualToNowHour]) {
            if ([self judgeNowMinuteIsLargeTheLastMinute]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL )isPickerHour0IsEqualToNowHour{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    NSString *nowHourStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"nowHourStr:%@",nowHourStr);
    if ([_pickerHour[0] isEqualToString:nowHourStr]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 检查选中的小时数是否是工作时间中的18点
- (BOOL )isWorkTimeAndHourStrIs18{
    
    if (_hoursType == UIHoursTypeWork && [_hourStr isEqualToString:@"18"]) {
        return YES;
    }else{
        return NO;
    }
}

// 检查是否是工作时间的18点，是：就修改分钟数组只显示00，否：就还原分钟数组
- (void)is18EndWorkToChangePickerMinute{
    
    if ([self isWorkTimeAndHourStrIs18]) {
        //是
        _pickerMinute = [NSMutableArray arrayWithObjects:@"00", nil];
    }else{
        //还原分钟数组
        [self updatePickerMinute];
    }
}




#pragma mark - UIPickerViewDataSource


- (NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

- (NSInteger )pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _pickerDate.count;
    }
    else if (component == 1){
        return _pickerHour.count;
    }
    else if (component == 2){
        return _pickerMinute.count;
    }
    else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        NSString *date = [NSString stringWithFormat:@"%@", _pickerDate[row]];
        return date;
    }
    else if (component == 1){
        NSString *hour = [NSString stringWithFormat:@"%@",_pickerHour[row]];
        return hour;
    }
    else if (component == 2){
        NSString *minute = [NSString stringWithFormat:@"%@",_pickerMinute[row]];
        return minute;
    }
    else{
        return @"";
    }
}

#pragma mark - UIPickerViewDelegate

- (CGFloat )pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40.0f;
}

- (CGFloat )pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.bounds.size.width/2.0;
    }
    else{
        return self.bounds.size.width/4.0f;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        
        self.dateStr = self.pickerDate[row];
        
        [self changePickerDate];
        
        //[pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:1];
        self.hourStr = [self.pickerHour objectAtIndex:[pickerView selectedRowInComponent:1]];
        
        //[pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
        self.minuteStr = [self.pickerMinute objectAtIndex:[pickerView selectedRowInComponent:2]];
        
    }
    else if (component == 1){
        
        self.hourStr = self.pickerHour[row];
        
        [self changePickerDate];
        
        //[pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
        self.minuteStr = [self.pickerMinute objectAtIndex:[pickerView selectedRowInComponent:2]];
        
    }
    else if(component == 2){
        self.minuteStr = self.pickerMinute[row];
    }
    NSLog(@"date:%@, hour:%@, minute:%@",self.dateStr, self.hourStr, self.minuteStr);
}








#pragma mark - 按钮点击
//取消按钮
- (IBAction)cancelBtnClicked:(id)sender {
    
    [self hiddenView];
}


//确认按钮
- (IBAction)confirmBtnClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(wHSelectedDateViewDelegateWithSelectedDateStr:)]) {
        [self.delegate wHSelectedDateViewDelegateWithSelectedDateStr:[NSString stringWithFormat:@"%@ %@:%@", _dateStr, _hourStr, _minuteStr]];
    }
    
    [self hiddenView];
    
}







#pragma mark - Animated Mthod
- (void)animatedIn
{
    //self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        //self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        //self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.controlForDismiss)
            {
                [self.controlForDismiss removeFromSuperview];
            }
            [self removeFromSuperview];
        }
    }];
}


#pragma mark - show or hide self
- (void)showView
{
    //处理时间数组
    [self initPickerDateAndHourAndMinute];
    
    [self refreshTheUserInterface];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (self.controlForDismiss)
    {
        [keywindow addSubview:self.controlForDismiss];
    }
    [keywindow addSubview:self];
    
    //self.center = CGPointMake(keywindow.bounds.size.width/2.0f,keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)hiddenView
{
    [self animatedOut];
}

- (void)refreshTheUserInterface
{
    if (nil == _controlForDismiss)
    {
        _controlForDismiss = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _controlForDismiss.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [_controlForDismiss addTarget:self action:@selector(touchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
}



@end
