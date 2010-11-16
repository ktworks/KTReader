//
//  KTRssData.h
//  KTReader
//
//  Created by kan on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTRssItem;

@interface KTRssData : NSObject {
	NSString *channelTitle;
	NSString *channelLink;
	NSString *channelDescription;
	NSString *channelLanguage;
	NSString *channelCopyright;
	NSString *channelDate;
	NSMutableArray *rssItems;
}

@property (nonatomic, retain) NSString *channelTitle;
@property (nonatomic, retain) NSString *channelLink;
@property (nonatomic, retain) NSString *channelDescription;
@property (nonatomic, retain) NSString *channelLanguage;
@property (nonatomic, retain) NSString *channelCopyright;
@property (nonatomic, retain) NSString *channelDate;
@property (nonatomic, retain) NSMutableArray *rssItems;

@end
