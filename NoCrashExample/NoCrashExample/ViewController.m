//
//  ViewController.m
//  NoCrashExample
//
//  Created by roki on 2019/3/15.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "ViewController.h"
#import "AView.h"

@interface ViewController ()
@property(weak,nonatomic)AView *a;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AView *a = [[AView alloc] init];
    [self.view addSubview:a];
    _a = a;
    [a test];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationA" object:nil];
    
    if (_a) {
        [_a removeFromSuperview];
    }
    
    
}


@end
