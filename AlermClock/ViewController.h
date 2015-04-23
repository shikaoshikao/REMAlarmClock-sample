//
//  ViewController.h
//  AlermClock
//
//  Created by TAICHI on 2014/09/02.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UILabel * hourLabel;
    IBOutlet UILabel * minutesEndLabel;
    IBOutlet UILabel * secondEndLabel;
    IBOutlet UILabel * hourEndLabel;
    IBOutlet UILabel * minutesLabel;
    IBOutlet UILabel * testLabel;
    IBOutlet UITextField * time1TextFieid;
    IBOutlet UITextField * time1TextFieid2;
    IBOutlet UITextField * time2TextFieid;
    IBOutlet UITextField * time2TextFieid2;
    int number;
    NSTimer * leftTimeTimer;
    AVAudioPlayer *audio ;
    NSTimer * nowTimeTimer;
    int f;
    NSDate * checkTime;
    NSDate * now;
//    NSDate*date;
//    NSString*date2;
//    NSString*date3;
    NSDate *minTime;
    NSDate *maxTime;
    UITextField *activeField;
    NSDateFormatter *df;
    NSDate *alarmTime[10];
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

-(IBAction)start;
-(IBAction)startAfter30;
-(void)checkLem;
-(void)checkLem2;
-(void)ringAlerm;
@end
