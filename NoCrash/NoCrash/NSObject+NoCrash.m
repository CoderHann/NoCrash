//
//  NSObject+NoCrash.m
//  NoCrash
//
//  Created by roki on 2019/3/15.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "NSObject+NoCrash.h"
#import "NCNoCrashManager.h"

@implementation NSObject (NoCrash)

#pragma mark - PublicMethos

+ (void)startNoCrashCatch {
    
}

+ (void)stopNoCrashCatch {
    
}

+ (void)catchUnrecognizedSelector {
    Method originForward = class_getInstanceMethod(self, @selector(forwardInvocation:));
    Method changedForward = class_getInstanceMethod(self,@selector(nocrash_forwardInvocation:));
    
    method_exchangeImplementations(originForward,changedForward);
    
    
    Method originM = class_getInstanceMethod(self, @selector(methodSignatureForSelector:));
    Method changedM = class_getInstanceMethod(self,@selector(nocrash_methodSignatureForSelector:));
    
    method_exchangeImplementations(originM,changedM);
}

- (NSMethodSignature *)nocrash_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self nocrash_methodSignatureForSelector:aSelector];
    
    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return signature;
}

- (void)nocrash_forwardInvocation:(NSInvocation *)anInvocation {
    // 崩溃消失，可以继续玩了
    NSLog(@"记录崩溃日志");
    
    NCNoCrashManager *noCrashManager = [NCNoCrashManager shareManager];
    [noCrashManager recordCrashIssue:[self class] selector:anInvocation.selector];
    
}

@end
