//
//  ViewController2.m
//  AlermClock
//
//  Created by TAICHI on 2015/01/20.
//  Copyright (c) 2015年 TAICHI. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [UIView animateWithDuration: 0.5
                          delay: 0.0
                        options: UIViewAnimationOptionAutoreverse |             UIViewAnimationOptionRepeat
                     animations: ^{label.alpha = 0;}
                     completion: ^(BOOL finished){label.alpha = 0;}];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
