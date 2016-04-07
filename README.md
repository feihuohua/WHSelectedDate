# WHSelectedDate

调用方法

WHSelectedDateView *view = [[WHSelectedDateView alloc] init];
view.frame = CGRectMake(0, self.view.bounds.size.height-240, self.view.bounds.size.width, 240);
//view.dateLimitNum = 0;
view.hoursType = UIHoursTypeWork;
view.minutesType = UIMinutesTypeAll;
view.delegate = self;
//view.titleString = @"测试";
    
    [view showView];
    
可以自行设置显示的时间类型


在下列枚举中更改响应的枚举值
typedef NS_ENUM(NSInteger, UIDateType) {
    UIDateTypeAll = 0,   //默认时间100天
    UIDateTypeLimit      //限制显示天数
};

typedef NS_ENUM(NSInteger, UIHoursType) {
    UIHoursTypeAll = 0,  //显示全天24小时
    UIHoursTypeWork      //显示工作时间
};

typedef NS_ENUM(NSInteger, UIMinutesType) {
    UIMinutesTypeAll = 0,     //60秒，每一秒一个数值
    UIMinutesTypeHalfHour,    //半分钟一个数值 00  30
    UIMinutesTypeQuarterHour  //15秒一个数值  00   15  30  45
};

修改相应的各个类型的数组的方法
//设置日期数组
- (void)updatePickerDate
//设置小时数组
- (void)updatePickerHour
//设置分钟数组
- (void)updatePickerMinute
//获取一个完整的分钟数组
- (NSMutableArray *)getAllMinutesArray

就可设置自己希望显示的时间形式的时间选择器

