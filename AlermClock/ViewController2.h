//
//  ViewController2.h
//  AlermClock
//
//  Created by TAICHI on 2015/01/20.
//  Copyright (c) 2015年 TAICHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController2 : UIViewController{
    IBOutlet UILabel * label;
    int time1;
    int time2;
}
-(IBAction)back:(id)sender;
-(void)setting;
@end
