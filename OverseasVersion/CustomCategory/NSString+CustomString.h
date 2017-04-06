//
//  NSString+CustomString.h
//  songShuFinance
//
//  Created by 梁家文 on 15/9/16.
//  Copyright (c) 2015年 李贵文. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (CustomString)
//获取当前时间
+(NSString *)getCurrentTime;
//获取选中的时间与当前时间相差多少天
+(NSString *)selectInvestTime:(NSString *) time;
//时间戳转换
+(NSString *)stringWithdateFrom1970:(long long)date withFormat:(NSString *)formatString;
+ (NSString *)stringWithDateFrom1970:(long long)date withFormat:(NSString *)formatString;
//禁止四舍五入
+ (NSString *)roundDown:(float)number afterPoint:(int)position;
+ (NSString *)roundUp:(double)number afterPoint:(int)position;
//获取idfa
+(NSString *)getIdfa;

//活期时间
+(NSString *)CurrentTime:(NSString  *)time;

//活期星期几
//+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;
//格式化钱的格式
+(NSString*)formatMoneyString:(double)money;
//拼接符号
+(NSString*)formatSpliceSignMoneyString:(double)money;

//拼接符号后两位特殊处理
+(NSString*)formatSpecialMoneyString:(double)money;
//获取英文月份
+(NSString *)getMonth:(NSString *)monthStr;
//picatime
+(NSString *)getpicaTime:(long long)date;
//获取上午还是下午
+(NSString *)timeslot:(NSString *)str;
//获取时间戳
+(NSString *)getTimestamp:(NSString *)dateStr;

@end

