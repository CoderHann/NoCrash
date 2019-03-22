//
//  NSMutableDictionary+NoCrash.m
//  NoCrash
//
//  Created by roki on 2019/3/22.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "NSMutableDictionary+NoCrash.h"
#import "NCNoCrashManager.h"
#import "NSObject+NoCrash.h"

@implementation NSMutableDictionary (NoCrash)
+ (void)startNoCrashCatch {
    
    // __NSDictionaryM:
    {
        Class mDictClass = NSClassFromString(@"__NSDictionaryM");
        unsigned int count;
        Method *methodList = class_copyMethodList(mDictClass, &count);
        
        for (NSInteger index = 0; index < count; index++) {
            Method tempMethod = methodList[index];
            NSString *name = NSStringFromSelector(method_getName(tempMethod));
//            NSLog(@"%@",name);
            if ([@"setObject:forKey:" isEqualToString:name]) {
                // 解决赋值为nil/空的场景下的crash
                Method changed = class_getInstanceMethod(self, @selector(nocrash_setObject:forKey:));
                method_exchangeImplementations(tempMethod, changed);
            }
            
        }
    }
}

- (void)nocrash_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject) {
        [self nocrash_setObject:anObject forKey:aKey];
    } else {
        NSLog(@"oops! add bad object");
    }
}
@end
