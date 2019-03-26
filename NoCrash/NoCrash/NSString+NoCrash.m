//
//  NSString+NoCrash.m
//  NoCrash
//
//  Created by roki on 2019/3/22.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "NSString+NoCrash.h"
#import "NCNoCrashManager.h"
#import "NSObject+NoCrash.h"

@implementation NSString (NoCrash)
+ (void)startNoCrashCatch {
    /*
     由于OC的string对象分为NSString面向开发，__NSCFConstantString(常量字符串 eg:NSString *str = @"abcdxxx")，NSTaggedPointerString(采用不同编码的短字符串 eg:NSString *str =[NSString stringWithFormat:@"123456789"]),__NSCFString(除了上面的两类)
     */
    
    {
        // NSString:
        
        Class strClass = NSClassFromString(@"NSString");
        unsigned int count;
        Method *methodList = class_copyMethodList(strClass, &count);
        
        for (NSInteger index = 0; index < count; index++) {
            Method tempMethod = methodList[index];
            NSString *name = NSStringFromSelector(method_getName(tempMethod));
//            NSLog(@"name:%@",name);
            if ([@"substringFromIndex:" isEqualToString:name]) {
                // 解决index异常下的crash
                
                Method changed = class_getInstanceMethod(self, @selector(nocrash_substringFromIndex:));
                method_exchangeImplementations(tempMethod, changed);
            } else if ([@"substringToIndex:" isEqualToString:name]) {
                // 解决index异常下的crash
                
                Method changed = class_getInstanceMethod(self, @selector(nocrash_substringToIndex:));
                method_exchangeImplementations(tempMethod, changed);
            }
        }
    }
    
    // __NSCFString:
    {
        Class strClass = NSClassFromString(@"__NSCFString");
        unsigned int count;
        Method *methodList = class_copyMethodList(strClass, &count);

        for (NSInteger index = 0; index < count; index++) {
            Method tempMethod = methodList[index];
            NSString *name = NSStringFromSelector(method_getName(tempMethod));
//            NSLog(@"name:%@",name);
            if ([@"characterAtIndex:" isEqualToString:name]) {
                // 解决index异常下的crash
                Method changed = class_getInstanceMethod(self, @selector(nocrash1_characterAtIndex:));
                method_exchangeImplementations(tempMethod, changed);
            } else if ([@"substringWithRange:" isEqualToString:name]) {
                // 解决index异常下的crash
                
                Method changed = class_getInstanceMethod(self, @selector(nocrash1_substringWithRange:));
                method_exchangeImplementations(tempMethod, changed);
            }

        }
    }
    
    // NSTaggedPointerString
    {
        Class strClass = NSClassFromString(@"NSTaggedPointerString");
        unsigned int count;
        Method *methodList = class_copyMethodList(strClass, &count);

        for (NSInteger index = 0; index < count; index++) {
            Method tempMethod = methodList[index];
            NSString *name = NSStringFromSelector(method_getName(tempMethod));
//            NSLog(@"%@",name);
            if ([@"characterAtIndex:" isEqualToString:name]) {
                // 解决赋值为nil/空的场景下的crash
                Method changed = class_getInstanceMethod(self, @selector(nocrash2_characterAtIndex:));
                method_exchangeImplementations(tempMethod, changed);
            } else if ([@"substringWithRange:" isEqualToString:name]) {
                // 解决index异常下的crash
                
                Method changed = class_getInstanceMethod(self, @selector(nocrash2_substringWithRange:));
                method_exchangeImplementations(tempMethod, changed);
            }

        }
    }
}

#pragma mark - substringWithRange
- (NSString *)nocrash1_substringWithRange:(NSRange)range {
    NSInteger index = range.location + range.length;
    if (index < 0 || index >= self.length) {
        return @"";
    } else {
        return [self nocrash1_substringWithRange:range];
    }
}

- (NSString *)nocrash2_substringWithRange:(NSRange)range {
    NSInteger index = range.location + range.length;
    if (index < 0 || index >= self.length) {
        return @"";
    } else {
        return [self nocrash2_substringWithRange:range];
    }
}

#pragma mark - substringToIndex
- (NSString *)nocrash_substringToIndex:(NSUInteger)to {
    if (to < 0 || to >= self.length) {
        return @"";
    } else {
        return [self nocrash_substringToIndex:to];
    }
}

#pragma mark - substringFromIndex
- (NSString *)nocrash_substringFromIndex:(NSUInteger)from {
    
    if (from < 0 || from >= self.length) {
        return @"";
    } else {
        return [self nocrash_substringFromIndex:from];
    }
}


#pragma mark - characterAtIndex

-(unichar)nocrash1_characterAtIndex:(NSUInteger)index {
    // 适用于__NSCFString和__NSCFConstantString
    if (index < self.length) {
        return [self nocrash1_characterAtIndex:index];
    } else {
        NSLog(@"oops! bad index:[%@ ]",[self class]);
        
        return [@" " nocrash1_characterAtIndex:0];
    }
}

-(unichar)nocrash2_characterAtIndex:(NSUInteger)index {
    // 适用于NSTaggedPointerString
    if (index < self.length) {
        return [self nocrash2_characterAtIndex:index];
    } else {
        NSLog(@"oops! bad index:[%@ ]",[self class]);

        return [@" " nocrash2_characterAtIndex:0];
    }
}


@end
