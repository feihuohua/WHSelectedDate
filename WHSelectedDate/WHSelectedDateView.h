//
//  WHSelectedDateView.h
//  WHSelectedDate
//
//  Created by houjing on 16/4/6.
//  Copyright © 2016年 eresl. All rights reserved.
//

#import <UIKit/UIKit.h>

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


@protocol WHSelectedDateViewDelegate <NSObject>

@optional
- (void)wHSelectedDateViewDelegateWithSelectedDateStr:(NSString *)dateString;

@end


@interface WHSelectedDateView : UIView

@property (nonatomic, weak) UIColor *bgBtnColor;//按钮背景颜色
@property (nonatomic, strong) NSString *titleString;//标题
//@property (nonatomic, assign) UIDateType dateType;//天数类型
@property (nonatomic, assign) UIHoursType hoursType;//小时类型
@property (nonatomic, assign) UIMinutesType minutesType;//分钟类型

@property (nonatomic, assign) NSInteger dateLimitNum;//限制显示天数

@property (nonatomic, assign) id<WHSelectedDateViewDelegate>delegate;


//展示界面
- (void)showView;

//隐藏界面
- (void)hiddenView;

@end
