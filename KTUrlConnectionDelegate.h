//
//  KTUrlConnectionDelegate.h
//  KTReader
//
//  Created by kan on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kConnectionDidFinishNotification @"connectionDidFinishNotification"

@interface KTUrlConnectionDelegate : NSObject {
	NSMutableData *data;
	NSString *path;
	NSIndexPath *indexPath;
}

@property (retain, readonly) NSMutableData *data;
@property (retain) NSString *path;
@property (retain) NSIndexPath *indexPath;

- (void)connectionWithPath: (NSString *)filePath;

@end
