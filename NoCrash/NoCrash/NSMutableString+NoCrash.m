//
//  NSMutableString+NoCrash.m
//  NoCrash
//
//  Created by roki on 2019/3/25.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import "NSMutableString+NoCrash.h"
#import "NCNoCrashManager.h"
#import "NSObject+NoCrash.h"

@implementation NSMutableString (NoCrash)
+ (void)startNoCrashCatch {
    
    // __NSCFString:
    {
        Class strClass = NSClassFromString(@"__NSCFString");
        unsigned int count;
        Method *methodList = class_copyMethodList(strClass, &count);
        
        for (NSInteger index = 0; index < count; index++) {
            Method tempMethod = methodList[index];
            NSString *name = NSStringFromSelector(method_getName(tempMethod));
            //            NSLog(@"name:%@",name);
            if ([@"insertString:atIndex:" isEqualToString:name]) {
                // 解决index异常下的crash
                
                Method changed = class_getInstanceMethod(self, @selector(nocrash_insertString:atIndex:));
                method_exchangeImplementations(tempMethod, changed);
            } else if ([@"deleteCharactersInRange:" isEqualToString:name]) {
                // 异常的边界
                Method changed = class_getInstanceMethod(self, @selector(nocrash_deleteCharactersInRange:));
                method_exchangeImplementations(tempMethod, changed);
            }
            
        }
    }
    
}

#pragma mark - deleteCharactersInRange:
- (void)nocrash_deleteCharactersInRange:(NSRange)range {
    NSInteger index = range.location + range.length;

    if ((range.location >= 0 && range.location <= self.length) && (index >= 0 && index <= self.length)) {
        [self nocrash_deleteCharactersInRange:range];
    } else {
        return ;
    }
}

#pragma mark - insertString:atIndex:
- (void)nocrash_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (loc < 0 || loc >= self.length) {
        
        return;
    } else {
        if (aString.length > 0) {
            [self nocrash_insertString:aString atIndex:loc];
        } else {
            return;
        }
    }
}
@end
