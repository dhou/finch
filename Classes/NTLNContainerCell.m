//
//  NTLNContainerCell.m
//  ntlniph
//
//  Created by houyr on 09-3-5.
//  Copyright 2009 marsbug. All rights reserved.
//

#import "NTLNContainerCell.h"


@implementation NTLNContainerCell

- (void)attachContainer:(UIView*)view {
	[container removeFromSuperview];
	[container release];
	container = [view retain];
	[self addSubview:view];
}

@end
