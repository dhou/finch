#import "NTLNConfigViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNFriendsViewController.h"
#import "NTLNColors.h"
#import "NTLNAccelerometerSensor.h"
#import "NTLNAboutViewController.h"
#import "NTLNRefleshIntervalConfigViewController.h"
#import "NTLNFetchCountConfigViewController.h"
#import "NTLNContainerCell.h"
#import "SettingsViewController.h"
#import "AccountManager.h"
#import "NewAccountViewController.h"
#import "ntlniphAppDelegate.h"

@implementation NTLNConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		[self.navigationItem setTitle:@"Settings"];
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
	//TODO: init iboutlet views programatically
	NSLog(@"configview initwithstle");
	if (self = [super initWithStyle:style]) {
		self.navigationItem.title = @"Home";
		aboutViewController = [[NTLNAboutViewController alloc] initWithStyle:UITableViewStyleGrouped];
		settingsController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
	NSLog(@"NTLNConfigViewController#didReceiveMemoryWarning");
}

- (void)dealloc {
	[aboutViewController release];
//	[usernameField release];
//	[passwordField release];
	
	[super dealloc];
}

- (void)loadView {
	[super loadView];
//
//	UIBarButtonItem *item = [[[UIBarButtonItem alloc] 
//							 initWithTitle:@"Done" 
//							 style:UIBarButtonItemStylePlain 
//							 target:self 
//							 action:@selector(doneButton:)] autorelease];
//	
//	[[self navigationItem] setRightBarButtonItem:item];

//	usernameField = [[NTLNConfigViewController textInputFieldForCellWithValue:
//						[[NTLNAccount instance] username]  secure:NO] retain];
//	usernameField.delegate = self;
//	passwordField = [[NTLNConfigViewController textInputFieldForCellWithValue:
//					 [[NTLNAccount instance] password]  secure:YES] retain];
//	passwordField.delegate = self;
//	
//	if (usernameField.text.length == 0 && passwordField.text.length == 0) {
//		[usernameField becomeFirstResponder];
//	}
}

- (void)viewWillAppear:(BOOL)animated
{
//	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
//	UITableView *tableView = self.tableView;
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
//	
//	usePostSwitch.on = [[NTLNConfiguration instance] usePost];
//	useSafariSwitch.on = [[NTLNConfiguration instance] useSafari];
//	darkColorThemeSwitch.on = [[NTLNConfiguration instance] darkColorTheme];
//	scrollLockSwitch.on = [[NTLNConfiguration instance] scrollLock];
//	showMoreTweetsModeSwitch.on = [[NTLNConfiguration instance] showMoreTweetMode];
//	shakeToFullscreenSwitch.on = [[NTLNConfiguration instance] shakeToFullscreen];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Cell editing


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if(indexPath.section == 0) {
		return YES;
	} else{
		return NO;
	}
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		if(indexPath.row < [[AccountManager sharedInstance] countOfAccounts]){
			[[AccountManager sharedInstance] removeAccountAtIndex:indexPath.row];
		}
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark - UITableView delegates

// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return UITableViewCellEditingStyleDelete;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
			return @"Twitter Account";
	}
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
			return 1 + [[AccountManager sharedInstance].accountsList count];
		case 1:
			return 1;
		case 2:
			return 1;
	}
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section)
	{
		case 0:
			if(indexPath.row < [[AccountManager sharedInstance] countOfAccounts]) {
				UITableViewCell *cell = [self textCellWithTitle:[[[AccountManager sharedInstance].accountsList objectAtIndex:indexPath.row] username]];
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				return cell;
			} else if ([[AccountManager sharedInstance] countOfAccounts] == 0 ) {
				return [self textCellWithTitle:@"Set Up Your Account..."];
			} else if ([[AccountManager sharedInstance] countOfAccounts] > 0 ) {
				return [self textCellWithTitle:@"Add New Account..."];
			}
			//switch (indexPath.row)
//			{
//				case 0:
//					return [self containerCellWithTitle:@"Username" view:usernameField];
//				case 1:
//					return [self containerCellWithTitle:@"Password" view:passwordField];
//			}
			break;
		case 1:
			return [self textCellWithTitle:@"Settings"];
		case 2:
			return [self textCellWithTitle:@"About NatsuLion for iPhone"];
	}

	return nil;
}

//TODO: update navbar with refresh and new tweet buttons when timeline views are pushed
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0){
		if (indexPath.row == [[AccountManager sharedInstance] countOfAccounts]) {
			[[self navigationController] pushViewController:[[NewAccountViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
		} else if (indexPath.row < [[AccountManager sharedInstance] countOfAccounts]) {
			[AccountManager sharedInstance].currentAccountIndex = indexPath.row;
			NSLog(@"current account is: %@", [[AccountManager sharedInstance] currentAccount].username);
			NTLNAppDelegate *app = [[UIApplication sharedApplication] delegate];
			[app resetTimelines];
			[[self navigationController] pushViewController:[app tabBarController] animated:YES];
		}
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		[[self navigationController] pushViewController:settingsController animated:YES];
	}else if(indexPath.section == 2 && indexPath.row == 0){
		[[self navigationController] pushViewController:aboutViewController animated:YES];
	}
}

//- (void)doneButton:(id)sender {
//	[usernameField resignFirstResponder];
//	[passwordField resignFirstResponder];
//	self.tabBarController.selectedIndex = 0;
//}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
		NSLog(@"accessory button clicked for %@", [[AccountManager sharedInstance] getAccountAtIndex:indexPath.row]);
//	[[self navigationController] pushViewController:blogDetailViewController animated:YES];
}


#pragma mark -
#pragma mark UI construction helpers

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//	NSString *t = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//	if (textField == usernameField) {
//		[[NTLNAccount instance] setUsername:t];
//		usernameEdited = YES;
//	} else if (textField == passwordField) {
//		[[NTLNAccount instance] setPassword:t];
//	}
//	
//	[friendsViewController removeLastReloadTime];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[textField resignFirstResponder];
//    return YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//	[usernameField resignFirstResponder];
//	[passwordField resignFirstResponder];
//	
//	if (usernameField) {
//		[[NTLNAccount instance] getUserId];
//	}
//
//}

+ (UITextField*)textInputFieldForCellWithValue:(NSString*)value secure:(BOOL)secure {
	UITextField *textField = [[[UITextField alloc] 
									initWithFrame:CGRectMake(110, 12, 160, 24)] autorelease];
	
	textField.text = value;
	textField.placeholder = @"Required";
	textField.secureTextEntry = secure;
	textField.keyboardType = UIKeyboardTypeASCIICapable;
	textField.returnKeyType = UIReturnKeyDone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	return textField;
}

- (UITableViewCell*)containerCellWithTitle:(NSString*)title view:(UIView*)view {
	NSString *MyIdentifier = title;
	NTLNContainerCell *cell = (NTLNContainerCell*)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[NTLNContainerCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.text = title;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell attachContainer:view];
	return cell;
}

- (UITableViewCell*)textCellWithTitle:(NSString*)title {
	NSString *MyIdentifier = title;
	NTLNContainerCell *cell = (NTLNContainerCell*)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[NTLNContainerCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.text = title;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

+ (UISwitch*)switchForCell {
	return [[[UISwitch alloc] initWithFrame:CGRectMake(190, 9, 0, 0)] autorelease];
}

@end

