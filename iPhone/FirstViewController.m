//
//  FirstViewController.m
//  TestTab
//
//  Created by kan on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "FirstViewController.h"
#import "KTRssParser.h"
#import "KTRssData.h"
#import "KTRssItem.h"
#import "KTTableViewCell.h"
#import "KTUrlConnectionDelegate.h"
#import "KTTableHeader.h"
#import "KTDateFormatter.h"


@implementation FirstViewController;

@synthesize navigationBar;
@synthesize ktCell;
@synthesize ktTableHeader;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		dataSource = [[NSMutableArray alloc] initWithCapacity:250];
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	// Segmented Control settings
	selectedSegControlId = 0;
	[self.ktTableHeader.segControl addTarget:self action:@selector(selectSegmentControl) forControlEvents:UIControlEventTouchDown];
	
	// Table settings
	UIViewController *cntrler = [[UIViewController alloc] initWithNibName:@"KTTableHeader" bundle:nil];
	self.ktTableHeader = (KTTableHeader *)cntrler.view;
	[self.ktTableHeader.segControl setTitle:@"All" forSegmentAtIndex:0];
	[self.ktTableHeader.segControl setTitle:@"All" forSegmentAtIndex:1];
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = 70;
	self.tableView.bounces = NO;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[parser release];
	[dataSource release];
	[ktCell release];
	[ktTableHeader release];
	[ktTableHeader release];
    [super dealloc];
}

// ------------------------
// Original Method
// ------------------------
- (void)getRssFeedWithUrl:(NSString *)urlStr {
	if (parser == nil) {
		parser = [[KTRssParser alloc] init];
	}
	
	[[AppDelegate_iPhone sharedAppDelegate] didStartNetworking];
	[parser parseXMLFileAtURL:[NSURL URLWithString:urlStr]];
	[[AppDelegate_iPhone sharedAppDelegate] didStopNetworking];
	
	if (dataSource != nil && [dataSource count] > 0) {
		[dataSource addObjectsFromArray:parser.rssData.rssItems];
	} else {
		dataSource = parser.rssData.rssItems;
	}
	[parser release];
	parser = nil;
}

- (void)loadImageWithUrl:(NSString *)imageUrl  WithIndexPath:(NSIndexPath *)indexPath {
	KTUrlConnectionDelegate *delegate;
	delegate = [[[KTUrlConnectionDelegate alloc] init] autorelease];
	delegate.indexPath = indexPath;
	[[NSNotificationCenter defaultCenter]
	 addObserver: self
	 selector: @selector(loadImageDidEnd:)
	 name: kConnectionDidFinishNotification
	 object: delegate];
	
	[delegate connectionWithPath:imageUrl];	
}

- (void)sortDataSource {
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [dataSource sortUsingDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
}

- (void)selectSegmentControl {
	selectedSegControlId = [self.ktTableHeader.segControl selectedSegmentIndex];
	[self.tableView reloadData];
}

// ------------------------
// TableViewController's delegate method
// ------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = [[NSString alloc] initWithFormat:@"%d",indexPath.row];
	KTTableViewCell *cell = (KTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil || !cell.didLoadLeftImage) {
		UIViewController *cntrler = [[UIViewController alloc] initWithNibName:@"KTTableViewCell" bundle:nil];
		cell = (KTTableViewCell *)cntrler.view;
		cell.reuseId = cellIdentifier;
		cell.didLoadLeftImage = NO;
		[cntrler release];
		
		// Cell Label settings
		cell.topLabel.text = [[dataSource objectAtIndex:indexPath.row] channelTitle];
		
		// Item Title
		cell.middleLabel.text = [[dataSource objectAtIndex:indexPath.row] title];
		
		// Item Update Date
		NSString *dcdate = [[dataSource objectAtIndex:indexPath.row] dcdate];
		cell.bottomLabel.text = [[[KTDateFormatter alloc] init] stringFromRssDateString:dcdate  relativeDate:YES];
		
		// Item Thumbnail
		cell.leftImage.image = [UIImage imageNamed:@"nophoto.png"];
		NSArray *imgUrls = [[dataSource objectAtIndex:indexPath.row] imgUrls];
		if (imgUrls != nil && [imgUrls count] > 0) {
			// RSSファイル内のIMGをサムネイルとして表示
			[self loadImageWithUrl:[imgUrls objectAtIndex:0] WithIndexPath:indexPath];
		} else {
			// RSSフィード元のfaviconをサムネイルとして表示
			[self loadImageWithUrl:@"http://www.asahi.com/favicon.ico" WithIndexPath:indexPath];
		}
		
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	KTRssItemViewController *imgCont = [[KTRssItemViewController alloc] initWithRssItemArray:self.dataSource CurrentIndex:indexPath.row];
//	[self.navigationController pushViewController:imgCont animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return self.ktTableHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (self.ktTableHeader) {
		//return [self.ktTableHeader bounds].size.height;
	}
	return 40.0;
}

// ------------------------
// KTUrlConnectionDelegate's delegate method
// ------------------------
#pragma mark Load Image
- (void) loadImageDidEnd: (NSNotification *)notification {
	KTUrlConnectionDelegate *connectionDelegate = (KTUrlConnectionDelegate *)[notification object];
	if (connectionDelegate != nil) {
		NSIndexPath *indexPath = nil;
		NSData *imageData = nil;
		
		if ([notification userInfo] == nil) {
			imageData = connectionDelegate.data;
			indexPath = connectionDelegate.indexPath;
		}
		
		if ((imageData != nil) && (indexPath != nil)) {
			KTTableViewCell *cell = (KTTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
			if (cell != nil) {
				// Image resize
				CGSize leftImageSize = cell.leftImage.image.size;
				UIImage *bufImg = [UIImage imageWithData:imageData];;
				CGSize bufsize = bufImg.size;
				CGFloat ratio = 0;
				if (bufsize.width > bufsize.height) {
					ratio = leftImageSize.width / bufsize.width;
				} else {
					ratio = leftImageSize.height / bufsize.height;
				}
				CGRect rect = CGRectMake(0.0, 0.0, ratio*bufsize.width*0.95, ratio*bufsize.height*0.95);
				UIGraphicsBeginImageContext(rect.size);
				[bufImg drawInRect:rect];
				bufImg = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();
				// Set Cell Left Image
				[cell.leftImage setImage:bufImg];
				[cell.leftImage sizeToFit];
				cell.didLoadLeftImage = YES;
			}
			
			//[[self.dataSource objectAtIndex:indexPath.row] setValue:imageData forKey:@"imageData"];
		}
	}	
}

@end
