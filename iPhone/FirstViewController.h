//
//  FirstViewController.h
//  TestTab
//
//  Created by kan on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTRssParser;
@class KTTableViewCell;
@class KTTableHeader;

@interface FirstViewController : UITableViewController {
	
	UINavigationBar *navigationBar;
	KTTableViewCell *ktCell;
	KTTableHeader *ktTableHeader;
	NSInteger selectedSegControlId;
	
	NSMutableArray *articleList;
	NSMutableArray *dataSource;

	KTRssParser *parser;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet KTTableViewCell *ktCell;
@property (nonatomic, retain) IBOutlet KTTableHeader *ktTableHeader;

- (void)getRssFeedWithUrl:(NSString *)urlStr;
- (void)loadImageWithUrl:(NSString *)imageUrl  WithIndexPath:(NSIndexPath *)indexPath;
- (void)sortDataSource;
- (void)selectSegmentControl;

@end
