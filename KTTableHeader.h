//
//  KTTableHeader.h
//  KTReader
//
//  Created by kan on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KTTableHeader : UIView {
	UISegmentedControl *segControl;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segControl;

@end
