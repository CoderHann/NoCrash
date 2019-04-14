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
        
        // 开启unrecognized selector类型的异常捕捉
        [NSObject catchUnrecognizedSelector];
        
        // 开启NSArray相关异常捕捉
        [NSArray startNoCrashCatch];
        
        // 开启NSMutableArray相关的异常捕捉
        [NSMutableArray startNoCrashCatch];
        
        // 开启NSMutableDictionary相关异常捕捉
        [NSMutableDictionary startNoCrashCatch];
        
        // 开启字符串相关的crash捕捉
        [NSString startNoCrashCatch];
        
        // 开启可变字符串的crash捕捉
        [NSMutableString startNoCrashCatch];
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

@end
