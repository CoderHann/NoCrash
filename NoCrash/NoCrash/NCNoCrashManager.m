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
        
    }
}

- (void)recordCrashIssue:(Class)cls selector:(SEL)sel {
    NSString *issue = [NSString stringWithFormat:@"oops! crashed:[%@ %@]",cls,NSStringFromSelector(sel)];
    NSLog(@"issue:%@",issue);
    
    if ([self.delegate respondsToSelector:@selector(noCrashManager:didInterceptCrashIssue:)]) {
        [self.delegate noCrashManager:self didInterceptCrashIssue:issue];
    }
}

#pragma mark - 配置各种crash参数

#pragma mark - unrecognized selector
- (void)configForUnrecognizedSelector {
    Class cls = [NSObject class];
    [cls needExchange];
}

@end
