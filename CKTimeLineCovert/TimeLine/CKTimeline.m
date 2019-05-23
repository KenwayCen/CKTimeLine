//
//  CKTimeline.m
//  CKTimeLineCovert
//
//  Created by Kenway-Pro on 2019/3/28.
//  Copyright © 2019 Kenway. All rights reserved.
//

#import "CKTimeline.h"

static NSString * const kDayTimeFormat = @"MM-dd HH:mm";
static NSString * const kYearFormat = @"yyyy-MM-dd";
static NSString * const kTimeFormat = @"HH:mm";

@implementation CKTimeline

- (NSString *)timelineConvert:(id)input{
    if ([input isKindOfClass:NSNumber.class]) {
        input = [input stringValue];
    }
    double t = [input length] == 13?[input doubleValue]/1000:[input doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDate *today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSinceDate:date];
    // 判断条件
    return [self convertStringWithInterval:interval];
}

/**
 v5.0.0
 30分钟内显示为 刚刚；
 30分钟-1小时：30分钟前
 12小时内显示 N小时前；
 12小时外: 48 小时内
    今天 xx:xx or 昨天 xx:xx；
    如果是前天，同时又在48小时内的，显示日期
    跨年则显示 年份
 超出48小时为显示日期加时间的方式： xx-xx xx:xx。
 */
- (NSString *)convertStringWithInterval:(NSTimeInterval)interval{
    NSDate *now = [NSDate date];
    NSDate *date = [now dateByAddingTimeInterval:-interval];
    if (interval < [self min30]) {
        return @"刚刚";
    }else if (interval < [self hour]){
        return @"30分钟前";
    }else if (interval < [self hour12]){
        return [NSString stringWithFormat:@"%ld小时前",(long)(interval/(60 * 60))];
    }else if (interval < [self hour24]){// 要根据具体日期来处理今天还是昨天
        NSString *dateString = [self dateStringFromDate:date withFormat:kTimeFormat];
        if ([self isToday:date]) {
            return [NSString stringWithFormat:@"今天 %@",dateString];
        }else {
            return [NSString stringWithFormat:@"昨天 %@",dateString];
        }
    }else if (interval < [self hour48]){// 需要根据具体日期处理是昨天还是前天（用日期显示了）
        if ([self isThisYear:date]) {
            if ([self isYesterday:date]) {
                NSString *dateString = [self dateStringFromDate:date withFormat:kTimeFormat];
                return [NSString stringWithFormat:@"昨天 %@",dateString];
            }else{
                NSString *dateString = [self dateStringFromDate:date withFormat:kDayTimeFormat];
                return dateString;
            }
        }else{//跨年
            NSString *dateString = [self dateStringFromDate:date withFormat:kYearFormat];
            return dateString;
        }
    }else if(interval < [self year]) {// 需要根据是否有跨年来计算具体的日期，如果不是今年，则直接显示年份
        if ([self isThisYear:date]) {
            NSString *dateString = [self dateStringFromDate:date withFormat:kDayTimeFormat];
            return dateString;
        }else{// 跨年
            NSString *dateString = [self dateStringFromDate:date withFormat:kYearFormat];
            return dateString;
        }
    }else{//跨年
        NSString *dateString = [self dateStringFromDate:date withFormat:kYearFormat];
        return dateString;
    }
}

- (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [self timezone];
    if (!format) {
        format = @"yyyy-MM-dd HH:mm";
    }
    formatter.dateFormat = format;
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


- (BOOL)isToday:(NSDate *)date{
    NSDateComponents *components = [self componentsInDate:date forUnits:NSCalendarUnitDay];
    NSInteger day = components.day;
    return ([self isThisYear:date] && [self isThisMonth:date] && day == [self today]);
}
- (BOOL)isYesterday:(NSDate *)date{
    NSDateComponents *components = [self componentsInDate:date forUnits:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay];
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSString *todayDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[self thisYear],(long)[self thisMonth],(long)[self today]];
    NSString *destDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.timeZone = [self timezone];
    formater.dateFormat = @"yyyy-MM-dd";
    NSDate *todayDate = [formater dateFromString:todayDateStr];
    NSDate *destDate = [formater dateFromString:destDateStr];
    if ([todayDate timeIntervalSinceDate:destDate] == (24* 60 * 60)) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isThisMonth:(NSDate *)date{
    NSDateComponents *components = [self componentsInDate:date forUnits:NSCalendarUnitMonth];
    NSInteger month = components.month;
    return ([self isThisYear:date] && month == [self thisMonth]);
}
- (BOOL)isThisYear:(NSDate *)date{
    NSDateComponents *components = [self componentsInDate:date forUnits:NSCalendarUnitYear];
    NSInteger year = components.year;
    return (year == [self thisYear]);
}

- (NSDateComponents *)componentsInDate:(NSDate *)date forUnits:(NSCalendarUnit)components {
    NSCalendar *calendaer = NSCalendar.currentCalendar;
    calendaer.timeZone = [self timezone];
    NSDateComponents *destComponents = [calendaer components:components fromDate:date];
    return destComponents;
}
- (NSInteger)thisYear{
    NSDateComponents *components = [self componentsInDate:[NSDate date] forUnits:NSCalendarUnitYear];
    return components.year;
}
- (NSInteger)thisMonth{
    NSDateComponents *components = [self componentsInDate:[NSDate date] forUnits:NSCalendarUnitMonth];
    return components.month;
}
- (NSInteger)today{
    NSDateComponents *components = [self componentsInDate:[NSDate date] forUnits:NSCalendarUnitDay];
    return components.day;
}

- (NSTimeInterval)min30{
    return 30 * 60;
}
- (NSTimeInterval)hour{
    return 60 * 60;
}
- (NSTimeInterval)hour12{
    return 12 * 60 * 60;
}
- (NSTimeInterval)hour24{
    return 24 * 60 * 60;
}
- (NSTimeInterval)hour48{
    return 48 * 60 * 60;
}
- (NSTimeInterval)year{
    return 365 * 24 * 60 * 60;
}

- (NSTimeZone *)timezone{
    return [NSTimeZone localTimeZone];
}

@end
