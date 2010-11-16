//
//  KTRssItem.h
//  KTReader
//
//  Created by kan on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTRssItem : NSObject {
	NSString *channelTitle;
	NSString *title;
	NSString *link;
	NSString *description;
	NSString *dcsubject;
	NSString *dccategory;
	NSString *dccreator;
	NSString *dcdate;
	NSString *timestamp;
	NSArray *imgUrls;
}

@property (nonatomic, retain) NSString *channelTitle;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *dcsubject;
@property (nonatomic, retain) NSString *dccategory;
@property (nonatomic, retain) NSString *dccreator;
@property (nonatomic, retain) NSString *dcdate;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic, retain) NSArray *imgUrls;

@end
