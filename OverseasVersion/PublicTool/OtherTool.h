//
//  OtherTool.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/15.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OtherTool : NSObject

+(void)addUnderlineLabel:(UILabel *)lab labText:(NSString *)text range:(NSRange)range;

+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month;

@end
