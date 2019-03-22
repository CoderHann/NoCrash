//
//  NSMutableArray+NoCrash.m
//  NoCrash
//
//  Created by roki on 2019/3/16.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "NSMutableArray+NoCrash.h"
#import "NCNoCrashManager.h"
#import "NSObject+NoCrash.h"

@implementation NSMutableArray (NoCrash)

+ (void)startNoCrashCatch {
    
    // __NSArrayM:
    {
        Class mutableArrClass = NSClassFromString(@"__NSArrayM");
        unsigned int count;
        Method *methodList = class_copyMethodList(mutableArrClass, &count);
        
        for (NSInteger index = 0; index < count; index++) {
            Method tempMethod = methodList[index];
            NSString *name = NSStringFromSelector(method_getName(tempMethod));
//            NSLog(@"%@",name);
            if ([@"insertObject:atIndex:" isEqualToString:name]) {
                // 解决[NSMutableArray addObject:nil or NULL]的崩溃
                //            BOOL addSuccess = class_addMethod(mutableArrClass, NSSelectorFromString(@"nocrash_insertObject:atIndex:"), class_getMethodImplementation([self class], @selector(nocrash_insertObject:atIndex:)), "v@:@Q");
                
                Method changed = class_getInstanceMethod(mutableArrClass, @selector(nocrash_insertObject:atIndex:));
                method_exchangeImplementations(tempMethod, changed);
                
            } else if ([@"objectAtIndexedSubscript:" isEqualToString:name]) {
                // 解决取数据的index异常不在范围内的崩溃mutableArr[index]
                Method changed = class_getInstanceMethod(self, @selector(nocrash_objectAtIndexedSubscript:));
                method_exchangeImplementations(tempMethod, changed);
                
            } else if ([@"removeObjectsInRange:" isEqualToString:name]) {
                // 解决取数据的index异常不在范围内的崩溃mutableArr[index]
                Method changed = class_getInstanceMethod(self, @selector(nocrash_removeObjectsInRange:));
                method_exchangeImplementations(tempMethod, changed);
                
            } else if ([@"replaceObjectAtIndex:withObject:" isEqualToString:name]) {
                // 解决替换对象index异常问题
                Method changed = class_getInstanceMethod(self, @selector(nocrash_replaceObjectAtIndex:withObject:));
                method_exchangeImplementations(tempMethod, changed);
            } else if ([@"objectAtIndex:" isEqualToString:name]) {
                // 解决objectAtIndex坐标异常的问题
                Method changed = class_getInstanceMethod(self, @selector(nocrash_objectAtIndex:));
                method_exchangeImplementations(tempMethod, changed);
            }
        }
        
    }
    
    // NSMutableArray
    {
        {
            // 解决[NSMutableArray removeObjectsAtIndexes:]crash
            Method tempM = class_getInstanceMethod(self, @selector(removeObjectsAtIndexes:));
            Method changed = class_getInstanceMethod(self, @selector(nocrash_removeObjectsAtIndexes:));
            
            method_exchangeImplementations(tempM, changed);
        }
    }
    
}

+ (void)stopNoCrashCatch {
    
}

#pragma mark - 插入空数据
- (void)nocrash_insertObject:(id)obj atIndex:(NSUInteger)index {
    
    if (!obj) {
        
        NSLog(@"oops! 插入数据为脏数据");
        return;
    }
    [self nocrash_insertObject:obj atIndex:index];
}

#pragma mark - Replace
- (void)nocrash_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    
    if (index < 0 || index >= self.count) {
        NSLog(@"oops! 不在范围内");
    } else {
        
        if (!anObject) {
            NSLog(@"oops! 插入数据为脏数据");
            return;
        } else {
            [self nocrash_replaceObjectAtIndex:index withObject:anObject];
        }
    }
    
    
}

#pragma mark - 删除指定index的元素
-(void)nocrash_removeObjectsInRange:(NSRange)range {
    NSInteger count = self.count;
    
    if (range.location < 0 || range.location + range.length > count) {
        NSLog(@"oops! 不在范围内");
    } else {
        [self nocrash_removeObjectsInRange:range];
    }
}

- (void)nocrash_removeObjectsAtIndexes:(NSIndexSet *)indexes {
    NSUInteger count = self.count;
    __block BOOL isExistBadIndex = NO;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= count) {
            isExistBadIndex = YES;
            *stop = YES;
        }
    }];
    
    if (isExistBadIndex) {
        NSLog(@"oops! 不在范围内");
    } else {
        [self nocrash_removeObjectsAtIndexes:indexes];
    }
    
}

#pragma mark - 下标异常
- (id)nocrash_objectAtIndexedSubscript:(NSUInteger)idx {
    
    if (idx >= 0 && idx < self.count) {
        return [self nocrash_objectAtIndexedSubscript:idx];
    } else {
        NSLog(@"oops! 数组越界");
        return nil;
    }
}

- (id)nocrash_objectAtIndex:(NSUInteger)index {
    if (index >= 0 && index < self.count) {
        return [self nocrash_objectAtIndexedSubscript:index];
    } else {
        NSLog(@"oops! 数组越界");
        return nil;
    }
}
@end
