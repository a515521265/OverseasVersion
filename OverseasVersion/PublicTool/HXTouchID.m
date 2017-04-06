//
//  HXTouchID.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/15.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "HXTouchID.h"

#import "projectHeader.h"

#define DELEGATE_RESPONDS(method) if (self.delegate && [self.delegate respondsToSelector:@selector(method)]) {[self.delegate method];}

@implementation HXTouchID

- (void)startCCTouchIDWithMessage:(NSString *)message fallbackTitle:(NSString *)fallbackTitle delegate:(id<HXTouchIDDelegate>)delegate {
    LAContext * context = [[LAContext alloc] init];
    context.localizedFallbackTitle = fallbackTitle;
    NSError * error = nil;
    self.delegate = delegate;
    NSAssert(self.delegate != nil, CCNotice(@"CCTouchIDDelegate 不能为空", @"CCTouchIDDelegate must be non-nil"));
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:message == nil ? CCNotice(@"默认提示信息", @"The Default Message") : message reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeSuccess)]) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate CCTouchIDAuthorizeSuccess];
                    }];
                }
            }else if (error) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeFailure)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeFailure];
                            }];
                        }
                    }
                        break;
                    case LAErrorUserCancel:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorUserCancel)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorUserCancel];
                            }];
                        }
                    }
                        break;
                    case LAErrorUserFallback:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorUserFallback)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorUserFallback];
                            }];
                        }
                    }
                        break;
                    case LAErrorSystemCancel:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorSystemCancel)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorSystemCancel];
                            }];
                        }
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorTouchIDNotEnrolled)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorTouchIDNotEnrolled];
                            }];
                        }
                    }
                        break;
                    case LAErrorPasscodeNotSet:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorPasscodeNotSet)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorPasscodeNotSet];
                            }];
                        }
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorTouchIDNotAvailable)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorTouchIDNotAvailable];
                            }];
                        }
                    }
                        break;
                    case LAErrorTouchIDLockout:
                    {
                        

                        
                        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启TouchID功能" reply:^(BOOL success, NSError * _Nullable error) {
                                if (success) {
                                    [self startCCTouchIDWithMessage:Internationalization(@"验证密码", @"Verify Password") fallbackTitle:@"" delegate:delegate];
                                }
                            }];
                        }];
                        
                        
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorTouchIDLockout)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorTouchIDLockout];
                            }];
                        }
                    }
                        break;
                    case LAErrorAppCancel:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorAppCancel)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorAppCancel];
                            }];
                        }
                    }
                        break;
                    case LAErrorInvalidContext:
                    {
                        if ([self.delegate respondsToSelector:@selector(CCTouchIDAuthorizeErrorInvalidContext)]) {
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [self.delegate CCTouchIDAuthorizeErrorInvalidContext];
                            }];
                        }
                    }
                        break;
                        
                        //                    default:
                        //                        break;
                }
            }
            
        }];
    }else {
        
        if (error.code == -8) {
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启TouchID功能" reply:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        [self startCCTouchIDWithMessage:Internationalization(@"验证密码", @"Verify Password") fallbackTitle:@"" delegate:delegate];
                    }
                }];
            }];
            
        }else{
            if ([self.delegate respondsToSelector:@selector(CCTouchIDIsNotSupport)]) {
                [self.delegate CCTouchIDIsNotSupport];
            }
        }

    }
    
}


@end
