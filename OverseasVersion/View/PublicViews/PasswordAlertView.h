//
//  PasswordAlertView.h
//  富文本测试
//
//  Created by 薄睿杰 on 16/5/26.
//  Copyright © 2016年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordAlertView : UIView

+ (instancetype)initJWAlertViewWithPaymentAmount:(NSString *)paymentAmount remainingBalance:(NSString *)remainingbalance singleTapEvent:(void(^)(NSString * ))event;


- (instancetype)jwAlertViewWithPaymentAmount:(NSString *)paymentAmount remainingBalance:(NSString *)remainingbalance singleTapEvent:(void(^)(NSString * ))event;


@property (nonatomic,assign)BOOL permanentShow; //永久显示

@property (nonatomic,strong) NSString * errorMessage;

@end


@interface LJWTextField : UITextField

@end
