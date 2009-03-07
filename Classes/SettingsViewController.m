//
//  SettingsViewController.m
//  ntlniph
//
//  Created by houyr on 09-3-4.
//  Copyright 2009 marsbug. All rights reserved.
//

#import "SettingsViewController.h"
#import "NTLNContainerCell.h"
#import "NTLNRefleshIntervalConfigViewController.h"
#import "NTLNFetchCountConfigViewController.h"
#import "NTLNConfigViewController.h"
#import "NTLNColors.h"
#import "NTLNConfiguration.h"
#import "NTLNAccelerometerSensor.h"


@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style {
	//TODO: init iboutlet views programatically
	NSLog(@"configview initwithstle");
	if (self = [super initWithStyle:style]) {
		self.navigationItem.title = @"Settings";
		refleshIntervalConfigViewController = [[NTLNRefleshIntervalConfigViewController alloc] initWithStyle:UITableViewStyleGrouped];
		fetchCountConfigViewController = [[NTLNFetchCountConfigViewController alloc] initWithStyle:UITableViewStyleGrouped];
	}
	return self;
}


- (void)dealloc {
	[refleshIntervalConfigViewController release];
	[fetchCountConfigViewController release];
	[usePostSwitch release];
	[useSafariSwitch release];
	[darkColorThemeSwitch release];
	[scrollLockSwitch release];
	[showMoreTweetsModeSwitch release];
	[shakeToFullscreenSwitch release];
    [super dealloc];
}


- (void)loadView {
	[super loadView];
	usePostSwitch = [[NTLNConfigViewController switchForCell] retain];
	useSafariSwitch = [[NTLNConfigViewController switchForCell] retain];
	darkColorThemeSwitch = [[NTLNConfigViewController switchForCell] retain];
	scrollLockSwitch = [[NTLNConfigViewController switchForCell] retain];
	showMoreTweetsModeSwitch = [[NTLNConfigViewController switchForCell] retain];
	shakeToFullscreenSwitch = [[NTLNConfigViewController switchForCell] retain];
}
/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	UITableView *tableView = self.tableView;
	NSIndexPath *tableSelection = [tableView indexPathForSelectedRow];
	[tableView deselectRowAtIndexPath:tableSelection animated:NO];
	
	usePostSwitch.on = [[NTLNConfiguration instance] usePost];
	useSafariSwitch.on = [[NTLNConfiguration instance] useSafari];
	darkColorThemeSwitch.on = [[NTLNConfiguration instance] darkColorTheme];
	scrollLockSwitch.on = [[NTLNConfiguration instance] scrollLock];
	showMoreTweetsModeSwitch.on = [[NTLNConfiguration instance] showMoreTweetMode];
	shakeToFullscreenSwitch.on = [[NTLNConfiguration instance] shakeToFullscreen];
	[tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NTLNConfiguration instance] setUsePost:usePostSwitch.on];
	[[NTLNConfiguration instance] setUseSafari:useSafariSwitch.on];
	[[NTLNConfiguration	instance] setDarkColorTheme:darkColorThemeSwitch.on];
	[[NTLNConfiguration instance] setScrollLock:scrollLockSwitch.on];
	[[NTLNConfiguration	instance] setShowMoreTweetMode:showMoreTweetsModeSwitch.on];
	[[NTLNConfiguration	instance] setShakeToFullscreen:shakeToFullscreenSwitch.on];
	
	[[NTLNColors instance] setupColors];
	[[NTLNAccelerometerSensor sharedInstance] updateByConfiguration];
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
			return @"Settings";
		case 1:
			return @"Advanced Settings";
	}
	
	return nil;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 4;
		case 1:
			return 4;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
				{
					NSString *title = nil; 
					int intervalSec = [[NTLNConfiguration instance] refreshIntervalSeconds];
					if (intervalSec == 0) {
						title = @"Auto refresh disabled";
					} else {
						title = [NSString stringWithFormat:@"Refresh Interval: %dmin", intervalSec / 60];
					}
					return [self textCellWithTitle:title];
				}
				case 1:
					return [self containerCellWithTitle:@"Use Safari" view:useSafariSwitch];
				case 2:
					return [self containerCellWithTitle:@"Dark color theme" view:darkColorThemeSwitch];
				case 3:
					return [self containerCellWithTitle:@"Shake to fullsceen" view:shakeToFullscreenSwitch];
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
				{
					int fetchCount = [[NTLNConfiguration instance] fetchCount];
					return [self textCellWithTitle:
							[NSString stringWithFormat:@"Fetching count: %d posts", fetchCount]];
				}
				case 1:
					return [self containerCellWithTitle:@"Autopagerize" view:showMoreTweetsModeSwitch];
				case 2:
					return [self containerCellWithTitle:@"No auto scroll" view:scrollLockSwitch];
				case 3:
					return [self containerCellWithTitle:@"Use POST Method" view:usePostSwitch];
			}
			break;
	}

    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0) {
		[[self navigationController] pushViewController:refleshIntervalConfigViewController animated:YES];
	} else if  (indexPath.section == 1 && indexPath.row == 0) {
		[[self navigationController] pushViewController:fetchCountConfigViewController animated:YES];
	}
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


@end

