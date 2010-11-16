//
//  AppDelegate_iPhone.h
//  KTReader
//
//  Created by kan on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	NSInteger _networkingCount;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

+ (AppDelegate_iPhone *)sharedAppDelegate;

- (void)didStartNetworking;
- (void)didStopNetworking;

@end

