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
    // __NSCFString:
    {
        Class strClass = NSClassFromString(@"__NSCFString");
        unsigned int count;
        Method *methodList = class_copyMethodList(strClass, &count);
        
        for (NSInteger index = 0; index < count; index++) {
            Method tempMethod = methodList[index];
            NSString *name = NSStringFromSelector(method_getName(tempMethod));
//            NSLog(@"%@",name);
            if ([@"characterAtIndex:" isEqualToString:name]) {
                // 解决赋值为nil/空的场景下的crash
                Method changed = class_getInstanceMethod(self, @selector(nocrash_characterAtIndex:));
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
            NSLog(@"%@",name);
            if ([@"characterAtIndex:" isEqualToString:name]) {
                // 解决赋值为nil/空的场景下的crash
                Method changed = class_getInstanceMethod(self, @selector(nonocrash_characterAtIndex:));
                method_exchangeImplementations(tempMethod, changed);
            }
            
        }
    }
}

-(unichar)nocrash_characterAtIndex:(NSUInteger)index {
    if (index < self.length) {
        return [self nocrash_characterAtIndex:index];
    } else {
        NSLog(@"oops! bad index:[%@ ]",[self class]);
        
        return [@" " nocrash_characterAtIndex:0];
    }
}

-(unichar)nonocrash_characterAtIndex:(NSUInteger)index {
    if (index < self.length) {
        return [self nocrash_characterAtIndex:index];
    } else {
        NSLog(@"oops! bad index:[%@ ]",[self class]);
        
        return [@" " nocrash_characterAtIndex:0];
    }
}
@end
