//
//  NSMutableArray+NoCrash.m
//  NoCrash
//
//  Created by roki on 2019/3/16.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "NSMutableArray+NoCrash.h"
#import "NCNoCrashManager.h"
#import <objc/message.h>

@implementation NSMutableArray (NoCrash)
+ (void)noCrashConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method originAdd = class_getInstanceMethod(self, @selector(addObject:));
        Method changedAdd = class_getInstanceMethod(self,@selector(nocrash_addObject:));
        
        method_exchangeImplementations(originAdd,changedAdd);
        
        Method originInsert = class_getInstanceMethod(self, @selector(insertObject:atIndex:));
        Method changedInsert = class_getInstanceMethod(self,@selector(nocrash_insertObject:atIndex:));
        
        method_exchangeImplementations(originInsert,changedInsert);
    });
}

- (void)nocrash_addObject:(id)anObject {
    if (anObject) {
        [self nocrash_addObject:anObject];
    } else {
        [[NCNoCrashManager shareManager] recordCrashIssue:[self class] selector:@selector(addObject:)];
    }
}

- (void)nocrash_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject) {
        [self nocrash_insertObject:anObject atIndex:index];
    } else {
        [[NCNoCrashManager shareManager] recordCrashIssue:[self class] selector:@selector(insertObject:atIndex:)];
    }
}

@end
