//
//  AView.m
//  NoCrashExample
//
//  Created by roki on 2019/3/15.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "AView.h"

@implementation AView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationComes) name:@"NotificationA" object:nil];
    
    NSMutableArray *mutaArr = [NSMutableArray array];
    id h = mutaArr[3];
    [mutaArr addObject:[self arrObject]];
    
}

- (id)arrObject {
    return nil;
}

- (void)notificationComes {
    NSLog(@"notificationComes");
}

- (void)dealloc {
    NSLog(@"ADealloced");
}

@end
