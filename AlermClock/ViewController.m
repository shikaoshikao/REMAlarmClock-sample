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
    
    //dateFormatterの設定
    df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"HH:mm"];
    
    // DatePickerの設定
    UIDatePicker* datePicker = [[UIDatePicker alloc]init];
    // 日付の表示モードを変更する(時分を表示)
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    // 分の刻みを10分おきにする
    datePicker.minuteInterval = 10;
    
    //24時間表示のために
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    datePicker.locale = locale;
    
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
    
    [self NowTime];
    [self showNowTime:(NSTimer *)nowTimeTimer];     //最初に1回現在時刻表示するメソッドを呼ぶ
    nowTimeTimer =[NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(showNowTime:) userInfo:nil repeats:YES];     //2回目以降は60秒おきに呼ぶ
    
}

//どっちのtetFieldに時間を入力するのかを判別するためのメソッド
- (void)text1Edited {
    activeField = time1TextFieid;
}
- (void)text2Edited {
    activeField = time2TextFieid;
}


//DatePickerの編集が完了したら結果をTextFieldに表示
-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    if (activeField == time1TextFieid){
        time1TextFieid.text = [df stringFromDate:picker.date];
        minTime = [NSDate dateWithTimeInterval: [[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:picker.date];
        NSLog(@"min:%@",minTime);
    }
    if (activeField == time2TextFieid) {
        time2TextFieid.text = [df stringFromDate:picker.date];
        maxTime = [NSDate dateWithTimeInterval: [[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:picker.date];
        //NSLog(@"max:%@",maxTime);
    }
}

//datepickerの完了ボタンが押された場合
-(void)pickerDoneClicked {
    [time1TextFieid resignFirstResponder];
    [time2TextFieid resignFirstResponder];
//    _activeField = nil;
}


//「今すぐ寝る」を押した時
-(IBAction)start{
    [self NowTime];//-(void)NowTimeを呼び出す(下の方にあるよ)
    [self checkLem];//-(void)checkLemを呼び出す
    NSLog(@"%@",now);
}

-(IBAction)startAfter30{
    [self after30minTime];//-(void)after30minTimeを呼び出す(下の方にあるよ)
    [self checkLem];//-(void)checkLemを呼び出す
    NSLog(@"%@",now);
}

//アラームを鳴らす時刻を決める
-(void)checkLem{
    int i = 0;
    int j = 0;
    NSComparisonResult maxNowResult = NSOrderedAscending;
    while (maxNowResult == NSOrderedAscending){
        checkTime = [now initWithTimeInterval:i*5400 sinceDate:now];
        maxNowResult = [checkTime compare:maxTime];
        NSComparisonResult minNowResult = [checkTime compare:minTime];
        if(minNowResult == NSOrderedDescending){
            alarmTime[j] = checkTime;
            j++;
            if(j >10){
                break;
            }
        }
        i++;
    }
    
    leftTimeTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
}

//残り時間を減らしていくよ！
-(void)countDown:(NSTimer *)leftTimeTimer{
    [self NowTime];
    NSTimeInterval delta = [alarmTime[0] timeIntervalSinceDate:now];
    NSLog(@"%d",(int)delta);
    int hour = (int)delta/3600;
    int minute = (int)delta/60 - hour*60;
    int second = (int)delta - minute*60 - hour*3600;
    hourEndLabel.text=[NSString stringWithFormat:@"%d",hour];
    minutesEndLabel.text=[NSString stringWithFormat:@"%d",minute];
    secondEndLabel.text=[NSString stringWithFormat:@"%d",second];
}

-(void)showNowTime:(NSTimer *)nowTimeTimer{
    now = [NSDate new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    // 時・分を取得
    flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    comps = [calendar components:flags fromDate:now];
    
    hourLabel.text = [NSString stringWithFormat:@"%d",(int)comps.hour];
    minutesLabel.text = [NSString stringWithFormat:@"%d",(int)comps.minute];

}


//現在時刻を取得
-(void)NowTime{
    now = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
}
//30分後の時刻を取得
-(void)after30minTime{
    now = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    now = [now initWithTimeInterval:30*60 sinceDate:now];
}


-(void)ringAlerm{
    if(f==1){
        NSString * path = [[NSBundle mainBundle]pathForResource:@"wind_sound"ofType:@"wav"];
        NSURL * url = [NSURL fileURLWithPath:path] ;
        audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audio play];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
