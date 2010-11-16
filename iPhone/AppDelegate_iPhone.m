//
//  AppDelegate_iPhone.m
//  KTReader
//
//  Created by kan on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "FirstViewController.h"

#import "AppDelegate_iPhone.h"

@interface AppDelegate_iPhone ()
@property (nonatomic, assign) NSInteger             networkingCount;
@end

@implementation AppDelegate_iPhone

+ (AppDelegate_iPhone *)sharedAppDelegate {
    return (AppDelegate_iPhone *) [UIApplication sharedApplication].delegate;
}

@synthesize window, tabBarController;
@synthesize networkingCount = _networkingCount;

#pragma mark -
#pragma mark Application lifecycle


#define RSS_FEED_URL1 @"http://www.groupon.jp/rss/?area=KANAGAWA"
#define RSS_FEED_URL2 @"http://allabout.co.jp/gm/cf/fashion/library/"
#define RSS_FEED_URL3 @"http://brigit.mochivation.com/feed/iphone"
#define RSS_FEED_URL4 @"http://rss.asahi.com/f/asahi_fashion"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	// Indicator settings
	UIActivityIndicatorView *indi;
	indi = [[[UIActivityIndicatorView alloc] 
			 initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray]
			autorelease];
	indi.frame = CGRectMake(160, 240, 20, 20);
	indi.contentMode = UIViewContentModeCenter;
	[indi startAnimating];
	[window addSubview: indi];
    [window makeKeyAndVisible];

	// ArticleList init
	[[tabBarController.viewControllers objectAtIndex:0] getRssFeedWithUrl:RSS_FEED_URL1];
	[[tabBarController.viewControllers objectAtIndex:0] getRssFeedWithUrl:RSS_FEED_URL2];
	[[tabBarController.viewControllers objectAtIndex:0] getRssFeedWithUrl:RSS_FEED_URL3];
	[[tabBarController.viewControllers objectAtIndex:0] getRssFeedWithUrl:RSS_FEED_URL4];
	[[tabBarController.viewControllers objectAtIndex:0] sortDataSource];
	
    [window addSubview:tabBarController.view];
	
	
	[indi stopAnimating];
	[indi removeFromSuperview];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


- (void)didStartNetworking {
    self.networkingCount += 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didStopNetworking {
    assert(self.networkingCount > 0);
    self.networkingCount -= 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (self.networkingCount != 0);
}

@end
