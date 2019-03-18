//
//  NCNoCrashManager.h
//  NoCrash
//
//  Created by roki on 2019/3/15.
//  Copyright © 2019 CoderHann. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NCNoCrashManager;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NCCrashedType) {
    NCCrashedTypeUnrecognizedSelector,//找不到方法的crash
    NCCrashedTypeMutableArrayAddNil,//可变数组添加空数据的crash
    NCCrashedTypeMutableArrayBadIndex,//可变数组异常索引的crash
    NCCrashedTypeOther,
};

@protocol NCNoCrashManagerDelegate <NSObject>

@optional
- (void)noCrashManager:(NCNoCrashManager *)manager crashedWithType:(NCCrashedType)crashType threadTrace:(NSString *)threadTrace;

@end

@interface NCNoCrashManager : NSObject

+ (instancetype)shareManager;

@property(weak,nonatomic)id<NCNoCrashManagerDelegate> delegate;

- (void)noCrashEnable:(BOOL)enable;

- (void)recordCrashIssue:(Class)cls selector:(SEL)sel;
@end

NS_ASSUME_NONNULL_END
