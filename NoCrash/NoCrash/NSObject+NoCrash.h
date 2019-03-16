//
//  NSObject+NoCrash.h
//  NoCrash
//
//  Created by roki on 2019/3/15.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NoCrash)
- (NSMethodSignature *)nocrash_methodSignatureForSelector:(SEL)aSelector;

- (void)nocrash_forwardInvocation:(NSInvocation *)anInvocation;

+ (void)needExchange;
@end

NS_ASSUME_NONNULL_END
