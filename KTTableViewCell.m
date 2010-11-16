//
//  KTTableViewCell.m
//  KTReader
//
//  Created by kan on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KTTableViewCell.h"

@implementation KTTableViewCell

@synthesize leftImage;
@synthesize topLabel;
@synthesize middleLabel;
@synthesize bottomLabel;
@synthesize reuseId;
@synthesize didLoadLeftImage; 

- (NSString *)reuseIdentifier {
	return self.reuseId;
}

@end
