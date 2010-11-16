//
//  KTTableViewCell.h
//  KTReader
//
//  Created by kan on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTTableViewCell : UITableViewCell {
	UIImageView *leftImage;
	UILabel *topLabel;
	UILabel *middleLabel;
	UILabel *bottomLabel;
	NSString *reuseId;
	Boolean didLoadLeftImage; 
}

@property (nonatomic, retain) IBOutlet UIImageView *leftImage;
@property (nonatomic, retain) IBOutlet UILabel *topLabel;
@property (nonatomic, retain) IBOutlet UILabel *middleLabel;
@property (nonatomic, retain) IBOutlet UILabel *bottomLabel;
@property (nonatomic, retain) NSString *reuseId;
@property (nonatomic) Boolean didLoadLeftImage;

- (NSString *)reuseIdentifier;

@end
