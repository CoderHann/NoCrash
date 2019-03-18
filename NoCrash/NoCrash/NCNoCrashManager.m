//
//  NCNoCrashManager.m
//  NoCrash
//
//  Created by roki on 2019/3/15.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "NCNoCrashManager.h"
#import <objc/message.h>
#import "NSObject+NoCrash.h"
#import "NSMutableArray+NoCrash.h"

@implementation NCNoCrashManager

static NCNoCrashManager *_manager = nil;

#pragma mark - 单例设置
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[self alloc] init];
        }
    });
    
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [super allocWithZone:zone];
        }
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initalBaseData];
    }
    
    return self;
}

- (void)initalBaseData {
    
}

#pragma mark - Public Methods

- (void)noCrashEnable:(BOOL)enable {
    if (enable) {
        
        [self configForUnrecognizedSelector];
        
        [self configForMutableArr];
        
    }
}

- (void)recordCrashIssue:(Class)cls selector:(SEL)sel {
    NSString *issue = [NSString stringWithFormat:@"oops! crashed:[%@ %@]",cls,NSStringFromSelector(sel)];
    NSLog(@"issue:%@",issue);
    
    [self recordWithCrashType:NCCrashedTypeUnrecognizedSelector];
}

- (void)recordWithCrashType:(NCCrashedType)crashType issue:(NSString *)issue {
    
    
    
    if ([self.delegate respondsToSelector:@selector(noCrashManager:crashedWithType:threadTrace:)]) {
        [self.delegate noCrashManager:self crashedWithType:NCCrashedTypeUnrecognizedSelector threadTrace:issue];
    }
}

- (void)recordWithCrashType:(NCCrashedType)crashType {
    
    if ([self.delegate respondsToSelector:@selector(noCrashManager:crashedWithType:threadTrace:)]) {
        [self.delegate noCrashManager:self crashedWithType:NCCrashedTypeUnrecognizedSelector threadTrace:@""];
    }
}

#pragma mark - 配置各种crash参数

#pragma mark - unrecognized selector
- (void)configForUnrecognizedSelector {
    Class cls = [NSObject class];
    [cls needExchange];
}

#pragma mark - mutableArray
- (void)configForMutableArr {
    Class mutableArrClass = NSClassFromString(@"__NSArrayM");
    unsigned int count;
    Method *methodList = class_copyMethodList(mutableArrClass, &count);
    
    for (NSInteger index = 0; index < count; index++) {
        Method tempMethod = methodList[index];
        NSString *name = NSStringFromSelector(method_getName(tempMethod));
        NSLog(@"%@",name);
        if ([@"insertObject:atIndex:" isEqualToString:name]) {
            // 解决[NSMutableArray addObject:nil or NULL]的崩溃
            BOOL addSuccess = class_addMethod(mutableArrClass, NSSelectorFromString(@"nocrash_insertObject:atIndex:"), class_getMethodImplementation([self class], @selector(nocrash_insertObject:atIndex:)), "v@:@Q");
            
            if (addSuccess) {
                Method changed = class_getInstanceMethod(mutableArrClass, NSSelectorFromString(@"nocrash_insertObject:atIndex:"));
                method_exchangeImplementations(tempMethod, changed);
            }
        } else if ([@"objectAtIndexedSubscript:" isEqualToString:name]) {
            // 解决取数据的index异常不在范围内的崩溃mutableArr[index]
            BOOL addSuccess = class_addMethod(mutableArrClass, NSSelectorFromString(@"nocrash_objectAtIndexedSubscript:"), class_getMethodImplementation([self class], @selector(nocrash_objectAtIndexedSubscript:)), "@@:Q");
            
            if (addSuccess) {
                Method changed = class_getInstanceMethod(mutableArrClass, NSSelectorFromString(@"nocrash_objectAtIndexedSubscript:"));
                method_exchangeImplementations(tempMethod, changed);
            }
        }
    }
}

- (void)nocrash_insertObject:(id)obj atIndex:(NSUInteger)index {
    
    if (!obj) {
        
        NSLog(@"oops! 插入数据为脏数据");
        return;
    }
    [self nocrash_insertObject:obj atIndex:index];
}

- (id)nocrash_objectAtIndexedSubscript:(NSUInteger)idx {
    
    NSMutableArray *mutable = self;
    
    if (idx >= 0 && idx < mutable.count) {
        return [self nocrash_objectAtIndexedSubscript:idx];
    } else {
        NSLog(@"oops! 数组越界");
        return nil;
    }
}

@end
