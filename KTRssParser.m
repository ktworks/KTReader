//
//  KTRssParser.m
//  KTReader
//
//  Created by kan on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KTDateFormatter.h"
#import "KTRssParser.h"
#import "KTRssData.h"
#import "KTRssItem.h"
#import "RegexKitLite.h"

@implementation KTRssParser

@synthesize rssData;
@synthesize parseErr;

- (void)dealloc {
	[rssData release];
	[parseErr release];
	[super dealloc];
}


// ------------------------
// Original Method
// ------------------------
- (void)parseXMLFileAtURL:(NSURL *)URL {
	parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];  
	//[parser setDelegate:(id <NSXMLParserDelegate>) self];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];  
	[parser setShouldReportNamespacePrefixes:NO];  
	[parser setShouldResolveExternalEntities:NO];  
	[parser parse];  
	self.parseErr = [parser parserError];  
	[parser release];  
} 


// ------------------------
// NSXMLParser's delegate method
// ------------------------
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	rssData = [[KTRssData alloc] init];
	rssData.rssItems = [[NSMutableArray alloc] initWithCapacity:0];
	startItemFlg = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	// 情報追加処理
	for (int i=0; i<[rssData.rssItems count]; i++) {
		// Channel Title を　RssItemオブジェクトに登録
		((KTRssItem*)[rssData.rssItems objectAtIndex:i]).channelTitle = rssData.channelTitle;
		
		// RssItemオブジェクト内のdcdateからtimestampを登録
		NSString *times = ((KTRssItem*)[rssData.rssItems objectAtIndex:i]).dcdate;
		((KTRssItem*)[rssData.rssItems objectAtIndex:i]).timestamp = [[[KTDateFormatter alloc] init] timestampStringFromRssDateString:times];
	}
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict 
{
	if ( [elementName isEqualToString:@"item"] ) {
		if (!startItemFlg) {
			startItemFlg = YES;
		}
		currentItem = [[KTRssItem alloc] init];
	} else {
		currentNodeName = [elementName copy];
		currentNodeContent = [[NSMutableString alloc] initWithCapacity:0];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName 
{
	if (!startItemFlg) {
		if ([elementName isEqualToString:@"title"]) {
			rssData.channelTitle = currentNodeContent;
		} else if ([elementName isEqualToString:@"link"]) {
			rssData.channelLink = currentNodeContent;
		} else if ([elementName isEqualToString:@"description"]) {
			rssData.channelDescription = currentNodeContent;
		} else if ([elementName isEqualToString:@"dc:language"]) {
			rssData.channelLanguage = currentNodeContent;
		} else if ([elementName isEqualToString:@"language"]) {
			rssData.channelLanguage = currentNodeContent;
		} else if ([elementName isEqualToString:@"copyright"]) {
			rssData.channelCopyright = currentNodeContent;
		} else if ([elementName isEqualToString:@"dc:date"]) {
			rssData.channelDate = currentNodeContent;
		} else if ([elementName isEqualToString:@"pubDate"]) {
			rssData.channelDate = currentNodeContent;
		}
	} else if ([elementName isEqualToString:@"item"]) {
		[rssData.rssItems addObject:currentItem];
		[currentItem release];
		currentItem = nil;
		
	} else if ([elementName isEqualToString:currentNodeName]) {
		NSString *keyName = [self changeNodeName:elementName];
		if (keyName != nil) {
			if ([keyName isEqualToString:@"description"]) {
				// Start 画像URLをブッコ抜キ
				NSArray *imgUrls = [self substrImageUrl:currentNodeContent];
				if (imgUrls != nil && [imgUrls count] > 0) {
					[currentItem setValue:imgUrls forKey:@"imgUrls"];
				}
				// End 画像URLをブッコ抜キ
			}
			[currentItem setValue:currentNodeContent forKey:keyName];
		}
		[currentNodeName release];
		currentNodeName = nil;
		[currentNodeContent release];
		currentNodeContent = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[currentNodeContent appendString:string];
}

/*
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	
}
*/

- (NSString *)changeNodeName:(NSString *)elementName {
	
	if ([elementName isEqualToString:@"title"]) {
		return elementName;
	}
	if ([elementName isEqualToString:@"link"]) {
		return elementName;
	}
	if ([elementName isEqualToString:@"description"]) {
		return elementName;
	}
	if ([elementName isEqualToString:@"dc:subject"]) {
		return @"dcsubject";
	}
	if ([elementName isEqualToString:@"dc:creator"]) {
		return @"dccreator";
	}
	if ([elementName isEqualToString:@"dc:date"]) {
		return @"dcdate";
	}
	if ([elementName isEqualToString:@"pubDate"]) {
		return @"dcdate";
	}
	return nil;
}

// 文字列からIMGタグを検索し、あればURL部分のみを抽出する関数
- (NSMutableArray *)substrImageUrl:(NSString *)targetStr {
	NSString *regexStr1 = @"[i|I]{1}[m|M]{1}[g|G]{1}\\s[s|S]{1}[r|R]{1}[c|C]{1}=[\"\']{1}";
	NSString *regexStr2 = @"https?://[^\"\'\\s]+";
	NSString *regexStr = [NSString stringWithFormat:@"%@%@",regexStr1,regexStr2];
	
	NSArray *matchedStr = nil;
	if ([targetStr isMatchedByRegex:regexStr]) {
		matchedStr = [targetStr componentsMatchedByRegex:regexStr];
	}
	
	NSMutableArray *returnStr = [[NSMutableArray alloc] initWithCapacity:0];
	NSString *buff = nil;
	for (int i=0; i<[matchedStr count]; i++) {
		buff = (NSString *)[matchedStr objectAtIndex:i];
		[returnStr addObject:[buff stringByReplacingOccurrencesOfRegex:regexStr1 withString:@""]];
	}
	
	return returnStr;
}

@end
