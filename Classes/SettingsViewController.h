//
//  SettingsViewController.h
//  ntlniph
//
//  Created by houyr on 09-3-4.
//  Copyright 2009 marsbug. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTLNRefleshIntervalConfigViewController, NTLNFetchCountConfigViewController;

@interface SettingsViewController : UITableViewController {
	UISwitch *usePostSwitch;
	UISwitch *useSafariSwitch;
	UISwitch *darkColorThemeSwitch;
	UISwitch *scrollLockSwitch;
	UISwitch *showMoreTweetsModeSwitch;
	UISwitch *shakeToFullscreenSwitch;
	
	NTLNRefleshIntervalConfigViewController *refleshIntervalConfigViewController;
	NTLNFetchCountConfigViewController *fetchCountConfigViewController;
}

- (UITableViewCell*)textCellWithTitle:(NSString*)title;
- (UITableViewCell*)containerCellWithTitle:(NSString*)title view:(UIView*)view;

@end
