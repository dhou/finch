#import <UIKit/UIKit.h>

@class NTLNFriendsViewController, NTLNFetchCountConfigViewController, NTLNRefleshIntervalConfigViewController, NTLNAboutViewController, NTLNContainerCell, SettingsViewController;

@interface NTLNConfigViewController : UITableViewController 
			<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
{
	NTLNAboutViewController *aboutViewController;
	NTLNFriendsViewController *friendsViewController;
	SettingsViewController *settingsController;
	
//	UITextField *usernameField;
//	UITextField *passwordField;
	
	BOOL usernameEdited;
}

+ (UITextField*)textInputFieldForCellWithValue:(NSString*)value secure:(BOOL)secure;
+ (UISwitch*)switchForCell;

- (UITableViewCell*)containerCellWithTitle:(NSString*)title view:(UIView*)view;
- (UITableViewCell*)textCellWithTitle:(NSString*)title;
	
//- (void)doneButton:(id)sender;

@end
