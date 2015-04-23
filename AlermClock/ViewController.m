//
//  ViewController.m
//  AlermClock
//
//  Created by TAICHI on 2014/09/02.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    f=0;
    minutesEndLabel.text=[NSString stringWithFormat:@"%d",number/60];
    secondEndLabel.text=[NSString stringWithFormat:@"%d",number%60];
    
    //dateFormatterの設定
    df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"HH:mm"];
    
    // DatePickerの設定
    UIDatePicker* datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    //24時間表示のために
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    datePicker.locale = locale;
    
    // 日付の表示モードを変更する(時分を表示)
    datePicker.datePickerMode = UIDatePickerModeTime;
    // 分の刻みを10分おきにする
    datePicker.minuteInterval = 10;
    
    // DatePickerを編集したら、updateTextFieldを呼び出す
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    // textFieldの入力をdatePickerに設定
    time1TextFieid.inputView = datePicker;
    time2TextFieid.inputView = datePicker;
    
    // Delegationの設定
    time1TextFieid.delegate = self;
    time2TextFieid.delegate = self;
    
    // DoneボタンとそのViewの作成
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle  = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    // 完了ボタンとSpacerの配置
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleBordered target:nil action:@selector(pickerDoneClicked)];
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer, spacer1, doneButton, nil]];
    
    // Viewの配置
    time1TextFieid.inputAccessoryView = keyboardDoneButtonView;
    time2TextFieid.inputAccessoryView = keyboardDoneButtonView;
    
    
    [time1TextFieid addTarget:self action:@selector(text1Edited) forControlEvents:UIControlEventEditingDidBegin];
    [time2TextFieid addTarget:self action:@selector(text2Edited) forControlEvents:UIControlEventEditingDidBegin];

    
}

- (void)text1Edited {
    activeField = time1TextFieid;
}
- (void)text2Edited {
    activeField = time2TextFieid;
}



#pragma mark DatePickerの編集が完了したら結果をTextFieldに表示
-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    if (activeField == time1TextFieid){
        time1TextFieid.text = [df stringFromDate:picker.date];
        minTime = picker.date;
        NSLog(@"min:%@",minTime);
    }
    if (activeField == time2TextFieid) {
        time2TextFieid.text = [df stringFromDate:picker.date];
        maxTime = picker.date;
        NSLog(@"max:%@",maxTime);
    }
}

#pragma mark datepickerの完了ボタンが押された場合
-(void)pickerDoneClicked {
    [time1TextFieid resignFirstResponder];
    [time2TextFieid resignFirstResponder];
//    _activeField = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkAlerm{
}


-(void)checkLem{
//    NSDate *now = [NSDate new];
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSUInteger flags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
//    NSDateComponents *components = [gregorian components:flags fromDate:now];
//    int minutes = (int)components.minute;
//    int hour = (int)components.hour;
//    int day = (int)components.day;
    now = [NSDate new];

    
    
    //    NSComparisonResult result = [date compare:];
    //    switch(result) {
    //        case NSOrderedSame: // 一致したとき
    //            NSLog(@"同じ日付です");
    //            break;
    //
    //        case NSOrderedAscending: // date1が小さいとき
    //            NSLog(@"異なる日付です（date1のが小）");
    //            break;
    //
    //        case NSOrderedDescending: // date1が大きいとき
    //            NSLog(@"異なる日付です（date1のが大）");
    //            break;
    //
}
-(void)checkLem2{
    NSDate *now = [NSDate date] ;
    NSString *date_converted;
    NSDate* date_source =[NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"H:m"];
    date_converted = [formatter stringFromDate:date_source];
    if (date_converted<time2TextFieid) {
        f=2;
    }
    //    NSComparisonResult result = [date_converted compare:date_converted];
    //        switch(result) {
    //        case NSOrderedSame: // 一致したとき
    //            NSLog(@"同じ日付です");
    //            break;
    //
    //        case NSOrderedAscending: // date1が小さいとき
    //            NSLog(@"異なる日付です（date1のが小）");
    //            break;
    //
    //        case NSOrderedDescending: // date1が大きいとき
    //            NSLog(@"異なる日付です（date1のが大）");
    //            break;
    //    }
}
-(void)ringAlerm{
    if(f==1){
        NSString * path = [[NSBundle mainBundle]pathForResource:@"wind_sound"ofType:@"wav"];
        NSURL * url = [NSURL fileURLWithPath:path] ;
        audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audio play];
    }
}





@end
