//
//  NewAccountViewController.m
//  ntlniph
//
//  Created by houyr on 09-3-6.
//  Copyright 2009 marsbug. All rights reserved.
//

#import "NewAccountViewController.h"
#import "NTLNAccount.h"
#import "NTLNContainerCell.h"
#import "NTLNConfigViewController.h"
#import "AccountManager.h"

@implementation NewAccountViewController

@synthesize accountType;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		self.title = @"Create Account";
    }
    return self;
}


- (void)dealloc {
	[usernameField release];
	[passwordField release];
	[accountType release];
    [super dealloc];
}

- (void)loadView {
	NSLog(@"Loading new account view");
	[super loadView];
	UIBarButtonItem *item = [[[UIBarButtonItem alloc] 
							 initWithTitle:@"Save" 
							 style:UIBarButtonItemStyleDone
							 target:self 
							 action:@selector(saveButton:)] autorelease];
	
	[[self navigationItem] setRightBarButtonItem:item];

	usernameField = [[NTLNConfigViewController textInputFieldForCellWithValue:
						@""  secure:NO] retain];
	usernameField.delegate = self;
	passwordField = [[NTLNConfigViewController textInputFieldForCellWithValue:
					 @""  secure:YES] retain];
	passwordField.delegate = self;
	
	if (usernameField.text.length == 0 && passwordField.text.length == 0) {
		[usernameField becomeFirstResponder];
	}
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.row)
	{
		case 0:
			return [self containerCellWithTitle:@"Username" view:usernameField];
		case 1:
			return [self containerCellWithTitle:@"Password" view:passwordField];
	}
	return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)saveButton:(id)sender {
	NSLog(@"Account type: %d", self.accountType);
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	
	NTLNAccount *account = [[NTLNAccount alloc] init];
	account.username = [usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	account.password = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	account.type = self.accountType;
	NSLog(@"account type set to %d", account.type);
	[[AccountManager sharedInstance] addAccount:account];
	[account release];
	
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark textfield delegate methods

//TODO:save accounts to accountslist
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//	NSString *t = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//	if (textField == usernameField) {
		//[[NTLNAccount instance] setUsername:t];
		//usernameEdited = YES;
//	} else if (textField == passwordField) {
		//[[NTLNAccount instance] setPassword:t];
//	}
	
//	[friendsViewController removeLastReloadTime];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	
	if (usernameField) {
		[[NTLNAccount instance] retrieveUserId];
	}

}

#pragma mark -
#pragma mark util methods

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


@end

