//
//  GWTipView.h
//  coreEnterpriseDW
//
//  Created by 李贵文 on 16/5/27.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWTipView : UIView

@property (strong, nonatomic) UILabel *messageLab;


+ (void)createTooltipViewWithMarkedWords:(NSString *)markWord view:(UIView *)showView;


- (id)initWithTipViewOfMessage:(NSString *)message LableFrame:(CGRect)lableFrame;

- (void)show;

+ (GWTipView *)createTipViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view;

// 固定高度
+ (GWTipView *)createTipMultipleViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view;

@end
