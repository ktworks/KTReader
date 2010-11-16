//
//  KTDateFormatter.m
//  KTReader
//
//  Created by kan on 10/11/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KTDateFormatter.h"
#import "RegexKitLite.h"


@implementation KTDateFormatter

- (id)init {
	self = [super init];
	if (self != nil) {
		[self setLocale:[NSLocale currentLocale]];
		[self setTimeZone:[NSTimeZone localTimeZone]];
	}
	return self;
}

- (NSDate *)dateFromRssDateString:(NSString *)dateStr {
	NSDate *datetime = nil;
	// For RSS2.0 Example "Thu, 11 Nov 2010 08:00:01 +0900"
	[self setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];// 実機バグ対応
	[self setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
	if ( (datetime = [self dateFromString:dateStr]) == nil ) {
		
		// For RSS1.0 Example "2010-11-11T08:00:01+09:00"
		[self setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] autorelease]];
		dateStr = [dateStr stringByReplacingOccurrencesOfRegex:@"(\\+09:00)" withString:@""];
		[self setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
		if ( (datetime = [self dateFromString:dateStr]) == nil ) {
			// Error
			return nil;
		}
	}
	return datetime;
}

- (NSString *)timestampStringFromRssDateString:(NSString *)dateStr {
	NSDate *datetime = [self dateFromRssDateString:dateStr];
	if (!datetime) {
		return @"";
	}
	return [NSString stringWithFormat:@"%qu",[datetime timeIntervalSinceNow]];
}

- (NSString *)stringFromRssDateString:(NSString *)dateStr relativeDate:(BOOL)relativeFlg {
	
	NSDate *datetime = [self dateFromRssDateString:dateStr];
	if (!datetime) {
		return @"";
	}
	
	if (relativeFlg) {
		NSInteger difSecond = [datetime timeIntervalSinceDate:[NSDate date]];
		NSInteger minsec = 60;
		NSInteger hoursec = minsec * minsec;
		NSInteger daysec = hoursec * 24;
		if (difSecond <= -daysec) {
			NSString *format = NSLocalizedString(@"%d日前",@"");
			dateStr = [NSString stringWithFormat:format, -difSecond / daysec];
		} else if (difSecond <= -hoursec) {
			NSString *format = NSLocalizedString(@"%d時間前",@"");
			dateStr = [NSString stringWithFormat:format, -difSecond / hoursec];
		} else if (difSecond <= -minsec) {
			NSString *format = NSLocalizedString(@"%d分前",@"");
			dateStr = [NSString stringWithFormat:format, -difSecond / minsec];
		} else if (difSecond <= 0) {
			NSString *format = NSLocalizedString(@"%d秒前",@"");
			dateStr = [NSString stringWithFormat:format, -difSecond];
		} else {
			dateStr = @"";
		}

	} else {
		[self setDateFormat:NSLocalizedString(@"MM月dd日 HH時mm分",@"for setDateFormat param's string")];
		dateStr = [self stringFromDate:datetime];
	}

	return dateStr;
}


@end
