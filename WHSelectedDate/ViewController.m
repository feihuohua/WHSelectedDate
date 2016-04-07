//
//  ViewController.m
//  WHSelectedDate
//
//  Created by houjing on 16/4/6.
//  Copyright © 2016年 eresl. All rights reserved.
//

#import "ViewController.h"
#import "WHSelectedDateView.h"

@interface ViewController ()<WHSelectedDateViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    
//    WHSelectedDateView *view = [[WHSelectedDateView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-240, self.view.bounds.size.width, 240)];
    WHSelectedDateView *view = [[WHSelectedDateView alloc] init];
    view.frame = CGRectMake(0, self.view.bounds.size.height-240, self.view.bounds.size.width, 240);
    //view.dateLimitNum = 0;
    view.hoursType = UIHoursTypeWork;
    view.minutesType = UIMinutesTypeAll;
    view.delegate = self;
    //view.titleString = @"测试";
    
    [view showView];
    
}


#pragma mark - WHSelectedDateViewDelegate
- (void)wHSelectedDateViewDelegateWithSelectedDateStr:(NSString *)dateString{
    
    NSLog(@"dateString:%@",dateString);
}


@end
