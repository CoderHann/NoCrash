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
    
//    NSMutableArray *mutaArr = [NSMutableArray array];
//    id h = mutaArr[3];
//    [mutaArr addObject:@"A"];
//    [mutaArr addObject:@"B"];
//    [mutaArr addObject:@"C"];
//    NSString *a= @"b";
//    NSString *bb= @"cc";
//
//    NSSet *set = [[NSSet alloc] initWithObjects:a,bb, nil];
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(2, 3)];
//    [mutaArr removeObjectsAtIndexes:indexSet];
//    [mutaArr removeObjectAtIndex:2];
//    [mutaArr replaceObjectAtIndex:0 withObject:@"x"];
//    [mutaArr removeObjectAtIndex:10];
    
//    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
//    [mutableDict setObject:nil forKey:@"xxl"];
//    mutableDict[@"kk"] = NULL;
//    id l = mutableDict[@"lkj"];
//    [mutableDict removeObjectForKey:@"asf"];
//    [mutableDict objectForKey:@"xx"];
    
    NSString *str = [NSString stringWithFormat:@"你好呀xxxxxx"];
    [str characterAtIndex:100];
    [str substringFromIndex:100];
    [str substringToIndex:100];
    [str substringWithRange:NSMakeRange(0, 100)];
    
//
//    NSString *strTagged = [NSString stringWithFormat:@"123456789"];
//    [strTagged characterAtIndex:100];
//    [strTagged substringFromIndex:100];
//    [strTagged substringToIndex:100];
//    [strTagged substringWithRange:NSMakeRange(0, 100)];
//
//    NSString *strConstant = @"123456789";
//    [strConstant characterAtIndex:100];
//    [strConstant substringFromIndex:100];
//    [strConstant substringToIndex:100];
//    [strConstant substringWithRange:NSMakeRange(0, 100)];
    
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:@"123456"];
    [mStr characterAtIndex:100];
    [mStr substringFromIndex:100];
    [mStr substringToIndex:100];
    [mStr substringWithRange:NSMakeRange(0, 100)];
    [mStr insertString:@"nihoa" atIndex:20];
    [mStr deleteCharactersInRange:NSMakeRange(6, 1)];
    
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
