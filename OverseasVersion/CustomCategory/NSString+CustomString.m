//
//  NSString+CustomString.m
//  songShuFinance
//
//  Created by 梁家文 on 15/9/16.
//  Copyright (c) 2015年 李贵文. All rights reserved.
//

#import "NSString+CustomString.h"
#import <AdSupport/ASIdentifierManager.h>
@implementation NSString (CustomString)
+(NSString *)getCurrentTime
{
    NSDate* date = [[NSDate alloc] init];
    date = [date dateByAddingTimeInterval:+3600*8];
    NSString * currentTime =[NSString stringWithFormat:@"%@",date];
    currentTime = [currentTime substringWithRange:NSMakeRange(0,10)];
    return currentTime;
}
+(NSString *)selectInvestTime:(NSString  *) time
{
    int t = [time intValue];
    NSDate* date = [[NSDate alloc] init];
    date = [date dateByAddingTimeInterval:(t-1)*3600*24+3600*8];
    NSString * currentTime =[NSString stringWithFormat:@"%@",date];
    currentTime = [currentTime substringWithRange:NSMakeRange(0,10)];
    return currentTime;
}


+(NSString *)CurrentTime:(NSString *)time
{
    int t = [time intValue];
    NSDate* date = [[NSDate alloc] init];
    date = [date dateByAddingTimeInterval:t*3600*24+3600*8];
    NSString * currentTime =[NSString stringWithFormat:@"%@",date];
    currentTime = [currentTime substringWithRange:NSMakeRange(5,5)];
    return currentTime;
}


#pragma mark - 时间戳转换
+ (NSString *)stringWithdateFrom1970:(long long)date withFormat:(NSString *)formatString{
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setDateFormat:formatString];
    NSString *dateString = [formatter stringFromDate:dateInfo];
    return dateString;
}
#pragma mark - 时间戳转换
+ (NSString *)stringWithDateFrom1970:(long long)date withFormat:(NSString *)formatString{
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSString *dateString = [formatter stringFromDate:dateInfo];
    return dateString;
}
#pragma mark - 禁止四舍五入
+(NSString *)roundDown:(float)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
//进位
+ (NSString *)roundUp:(double)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
+(NSString *)getIdfa{
    NSString * idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}
//活期星期几
//+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
//    
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
//    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//    
//    [calendar setTimeZone: timeZone];
//    
//    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
//    
//    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
//    
//    return [weekdays objectAtIndex:theComponents.weekday];
//    
//}
+(NSString*)formatMoneyString:(double)money{
    
    NSString *formatterDouble = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:money] numberStyle:NSNumberFormatterCurrencyStyle];
    NSMutableString *deleteLetter = [NSMutableString stringWithString:formatterDouble];
    for (int i =0; i< deleteLetter.length; i++) {
        unichar c = [deleteLetter characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ((c >= 'A' && c <= 'Z')||(c >= 'a' && c <= 'z')) {
            [deleteLetter deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:deleteLetter];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\| ~＜＞$€^•'@#$%^&*()_+'\"￥ "];
    NSString *moneyString = [newstr stringByTrimmingCharactersInSet:set];
    return moneyString;
}


//拼接符号
+(NSString*)formatSpliceSignMoneyString:(double)money{

    NSString *formatterDouble = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:money] numberStyle:NSNumberFormatterCurrencyStyle];
    NSMutableString *deleteLetter = [NSMutableString stringWithString:formatterDouble];
    for (int i =0; i< deleteLetter.length; i++) {
        unichar c = [deleteLetter characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ((c >= 'A' && c <= 'Z')||(c >= 'a' && c <= 'z')) {
            [deleteLetter deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:deleteLetter];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\| ~＜＞$€^•'@#$%^&*()_+'\"￥ "];
    NSString *moneyString = [newstr stringByTrimmingCharactersInSet:set];
    
    
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:moneyString];
    [String1 insertString:@"₱" atIndex:0];
    
    
    return String1;

}


//拼接符号后两位特殊处理
+(NSString*)formatSpecialMoneyString:(double)money{

    NSString *formatterDouble = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:money] numberStyle:NSNumberFormatterCurrencyStyle];
    NSMutableString *deleteLetter = [NSMutableString stringWithString:formatterDouble];
    for (int i =0; i< deleteLetter.length; i++) {
        unichar c = [deleteLetter characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ((c >= 'A' && c <= 'Z')||(c >= 'a' && c <= 'z')) {
            [deleteLetter deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:deleteLetter];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\| ~＜＞$€^•'@#$%^&*()_+'\"￥ "];
    NSString *moneyString = [newstr stringByTrimmingCharactersInSet:set];
    
    
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:moneyString];
    [String1 insertString:@"₱" atIndex:0];
    
    [String1 insertString:@"[" atIndex:String1.length-2];
    
    [String1 insertString:@"]" atIndex:String1.length];
    
    return String1;

}


+(NSString *)getMonth:(NSString *)monthStr{

    if ([monthStr isEqualToString:@"01"]) {
        return @"January";
    }else if ([monthStr isEqualToString:@"02"]){
        return @"February";
    }else if ([monthStr isEqualToString:@"03"]){
        return @"March";
    }else if ([monthStr isEqualToString:@"04"]){
        return @"April";
    }else if ([monthStr isEqualToString:@"05"]){
        return @"May";
    }else if ([monthStr isEqualToString:@"06"]){
        return @"June";
    }else if ([monthStr isEqualToString:@"07"]){
        return @"July";
    }else if ([monthStr isEqualToString:@"08"]){
        return @"August";
    }else if ([monthStr isEqualToString:@"09"]){
        return @"September";
    }else if ([monthStr isEqualToString:@"10"]){
        return @"October";
    }else if ([monthStr isEqualToString:@"11"]){
        return @"November";
    }else if ([monthStr isEqualToString:@"12"]){
        return @"December";
    }else{
        return @"unknown";
    }
//    Jan.January一月
//    Feb.February二月
//    Mar.March三月
//    Apr.April四月
//    May.May五月
//    Jun.June六月
//    Jul.July七月
//    Aug.August八月
//    Sep.September九月
//    Oct.October十月
//    Nov.November十一月
//    Dec.December十二月
}

+(NSString *)getpicaTime:(long long)date{

    return [NSString stringWithFormat:@"%@%@%@",[NSString getMonth:[NSString stringWithdateFrom1970:date withFormat:@"MM"]],[NSString stringWithdateFrom1970:date withFormat:@" dd,yyyy HH:mm "],[NSString timeslot:[NSString stringWithdateFrom1970:date withFormat:@"a"]]];
}

+(NSString *)timeslot:(NSString *)str{
    if ([str isEqualToString:@"上午"]) {
        return @"AM";
    }else if ([str isEqualToString:@"下午"]){
        return @"PM";
    }else{
        return str;
    }
}

//获取时间戳
+(NSString *)getTimestamp:(NSString *)dateStr{

    NSString * dateString=dateStr;
    //设置转换格式
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-ddhh:mm:ss"];
    //NSString转NSDate
    NSDate*date=[formatter dateFromString:dateString];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
    
}

@end
