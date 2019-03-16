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

@protocol NCNoCrashManagerDelegate <NSObject>

@optional
- (void)noCrashManager:(NCNoCrashManager *)manager didInterceptCrashIssue:(NSString *)issue;

@end

@interface NCNoCrashManager : NSObject

+ (instancetype)shareManager;

@property(weak,nonatomic)id<NCNoCrashManagerDelegate> delegate;

- (void)noCrashEnable:(BOOL)enable;

- (void)recordCrashIssue:(Class)cls selector:(SEL)sel;
@end

NS_ASSUME_NONNULL_END
