//
//  NSObject+NoCrash.h
//  NoCrash
//
//  Created by roki on 2019/3/15.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NoCrash)

+ (void)catchUnrecognizedSelector;

+ (void)uncatchUnrecognizedSelector;

/**
 开启异常捕获
 */
+ (void)startNoCrashCatch;

/**
 关闭异常捕获
 */
+ (void)stopNoCrashCatch;
@end

NS_ASSUME_NONNULL_END
