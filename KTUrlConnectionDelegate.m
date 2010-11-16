//
//  KTUrlConnectionDelegate.m
//  KTReader
//
//  Created by kan on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KTUrlConnectionDelegate.h"


@implementation KTUrlConnectionDelegate

@synthesize data, path, indexPath;

- (void)connectionWithPath: (NSString *)filePath {
	
	if ([path isEqualToString:filePath] == FALSE) {
		[path release];
		path = filePath;
		[path retain];
	}
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[NSNotificationCenter defaultCenter] postNotificationName: kConnectionDidFinishNotification
														object: self
													  userInfo: [NSDictionary dictionaryWithObject: error forKey: @"error"]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	data = [NSMutableData data];
	[data retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)partialData {
	[data appendData:partialData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[[NSNotificationCenter defaultCenter] postNotificationName: kConnectionDidFinishNotification
														object: self];
}

- (void)dealloc {
	[path release];
	[indexPath release];
	[data release];
	[super dealloc];
}

@end
