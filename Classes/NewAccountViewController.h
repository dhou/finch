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
}

- (UITableViewCell*)containerCellWithTitle:(NSString*)title view:(UIView*)view;

@end
