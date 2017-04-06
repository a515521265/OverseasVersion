//
//  OtherTool.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/15.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "OtherTool.h"


@implementation OtherTool

+(void)addUnderlineLabel:(UILabel *)lab labText:(NSString *)text range:(NSRange)range{
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange contentRange = range;
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    lab.attributedText = content;
    
}

#pragma mark - 获取某年某月的天数
+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

/*
 
 NSLog(@"%ld",(long)[self howManyDaysInThisYear:2016 withMonth:1]);
 NSLog(@"%ld",(long)[self howManyDaysInThisYear:2016 withMonth:2]);
 NSLog(@"%ld",(long)[self howManyDaysInThisYear:2016 withMonth:3]);
 NSLog(@"%ld",(long)[self howManyDaysInThisYear:2016 withMonth:4]);
 NSLog(@"%ld",(long)[self howManyDaysInThisYear:2016 withMonth:5]);
 NSLog(@"%ld",(long)[self howManyDaysInThisYear:2016 withMonth:6]);
 NSLog(@"%ld",(long)[self howManyDaysInThisYear:2016 withMonth:7]);
 NSLog(@"%ld",(long)[self howManyDaysInThisYear:2016 withMonth:8]);
 
 */


@end
