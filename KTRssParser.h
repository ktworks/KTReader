//
//  KTRssParser.h
//  KTReader
//
//  Created by kan on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTRssData;
@class KTRssItem;

@interface KTRssParser : NSObject {
	KTRssData *rssData;
	NSXMLParser *parser;
	NSError *parseErr;
	KTRssItem *currentItem;
	NSString *currentNodeName;
	NSMutableString *currentNodeContent;
	bool startItemFlg;
}

@property (nonatomic, retain) KTRssData *rssData;
@property (nonatomic, retain) NSError *parseErr;

- (void)parseXMLFileAtURL:(NSURL *)URL;
- (NSString *)changeNodeName:(NSString *)elementName;
- (NSMutableArray *)substrImageUrl:(NSString *)targetStr;

@end
