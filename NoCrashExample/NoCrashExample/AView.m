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
    [mutaArr addObject:@"A"];
//    [mutaArr addObject:@"B"];
//    [mutaArr addObject:@"C"];
    NSString *a= @"b";
    NSString *bb= @"cc";
    
    NSSet *set = [[NSSet alloc] initWithObjects:a,bb, nil];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(2, 3)];
    [mutaArr removeObjectsAtIndexes:indexSet];
//    [mutaArr removeObjectAtIndex:2];
//    [mutaArr replaceObjectAtIndex:0 withObject:@"x"];
//    [mutaArr removeObjectAtIndex:10];
    
    NSLog(@"");
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
