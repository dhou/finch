//
//  NTLNContainerCell.h
//  ntlniph
//
//  Created by houyr on 09-3-5.
//  Copyright 2009 marsbug. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NTLNContainerCell : UITableViewCell
{
	UIView *container;
}

- (void)attachContainer:(UIView*)view;

@end