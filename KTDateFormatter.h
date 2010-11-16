//
//  KTDateFormatter.h
//  KTReader
//
//  Created by kan on 10/11/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KTDateFormatter : NSDateFormatter {

}

- (NSDate *)dateFromRssDateString:(NSString *)dateStr;
- (NSString *)timestampStringFromRssDateString:(NSString *)dateStr;
- (NSString *)stringFromRssDateString:(NSString *)dateStr relativeDate:(BOOL)relativeFlg;

@end
