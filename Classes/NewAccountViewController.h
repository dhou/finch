//
//  NewAccountViewController.h
//  ntlniph
//
//  Created by houyr on 09-3-6.
//  Copyright 2009 marsbug. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewAccountViewController : UITableViewController <UITextFieldDelegate> {
	UITextField *usernameField;
	UITextField *passwordField;
	NSString* accountType;
}

@property (nonatomic, assign) NSString* accountType;

- (UITableViewCell*)containerCellWithTitle:(NSString*)title view:(UIView*)view;

@end
