#import "NTLNTimelineViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNColors.h"

#define kCustomButtonHeight		30.0

@interface NTLNTimelineViewController(Private)
- (UIView*)showMoreTweetView;
- (UIView*)nowloadingView;

@end


@implementation NTLNTimelineViewController(View)

#pragma mark Private

- (UIView*)showMoreTweetView {
	UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	v.backgroundColor = [UIColor blackColor];
	
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	label.text = @"Autopagerizing...";
	label.font = [UIFont boldSystemFontOfSize:16];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	label.backgroundColor =  [UIColor blackColor];
	[v addSubview:label];
	
	UIActivityIndicatorView *ai = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(60, 8, 24, 24)] autorelease];
	ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	ai.hidesWhenStopped = YES;
	autoloadActivityView = ai;
	//	[ai startAnimating];
	[v addSubview:ai];
	
	return v;
}

- (UIView*)nowloadingView {
	UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 40)] autorelease];
	v.backgroundColor = [[NTLNColors instance] scrollViewBackground];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	label.text = @"Loading...";
	label.font = [UIFont boldSystemFontOfSize:14];
	label.textColor = [[NTLNColors instance] textForground];
	label.textAlignment = UITextAlignmentCenter;
	label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	label.backgroundColor = [[NTLNColors instance] scrollViewBackground];
	label.shadowColor = [[NTLNColors instance] textShadow];
	label.shadowOffset = CGSizeMake(0, 1);	
	[v addSubview:label];
	
	UIActivityIndicatorView *ai = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 8, 24, 24)] autorelease];
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	} else {
		ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	}
	[ai startAnimating];
	[v addSubview:ai];
	
	return v;
}

- (void)setupTableView {
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	footerShowMoreTweetView = [[self showMoreTweetView] retain];
}

- (void)setupNavigationBar {
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	// "Segmented" control to the right
	UISegmentedControl *segmentedControl = [[[UISegmentedControl alloc] initWithItems:
											 [NSArray arrayWithObjects:
											  @"New",
											  @"Reload",
											  nil]] autorelease];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, kCustomButtonHeight);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	segmentedControl.tintColor = [UIColor darkGrayColor];
	
//	defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[[UIBarButtonItem alloc] initWithCustomView:segmentedControl] autorelease];
	self.tabBarController.navigationItem.rightBarButtonItem = segmentBarItem;
	
//	reloadButton = [[UIBarButtonItem alloc] 
//					initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
//					target:self action:@selector(reloadButton:)];
//	
//	[[[self tabBarController] navigationItem] setRightBarButtonItem:reloadButton];
}

- (void)segmentAction:(id)sender
{
	UISegmentedControl* segCtl = sender;
	// the segmented control was clicked, handle it here 
	NSLog(@"segment clicked %d", [segCtl selectedSegmentIndex]);
	if([segCtl selectedSegmentIndex] == 0){
		//new tweet
//		NTLNAppDelegate* appDelegate = (NTLNAppDelegate*)[UIApplication sharedApplication].delegate;
		[appDelegate showTweetView];
	} else {
		//reload view
		if (activeTwitterClient == nil) {
			[self getTimelineWithPage:0 autoload:NO];
		} else {
			[activeTwitterClient cancel];
		}
	}
}

- (void)insertNowloadingViewIfNeeds {
	if (timeline.count == 0 && nowloadingView == nil) {
		nowloadingView = [[self nowloadingView] retain];
		[self.tableView addSubview:nowloadingView];
	}
}

- (void)removeNowloadingView {
	if (nowloadingView) {
		[nowloadingView removeFromSuperview];
		[nowloadingView release];
		nowloadingView = nil;
	}
}

- (void)attachOrDetachAutopagerizeView {
	if ([[NTLNConfiguration instance] showMoreTweetMode]) {
		if (timeline.count >= 20 && self.tableView.tableFooterView == nil) {
			self.tableView.tableFooterView = footerShowMoreTweetView;
		}
		//		if (self.tableView.tableFooterView && currentPage >= 10) {
		//			self.tableView.tableFooterView = nil;
		//		}
	} else if (self.tableView.tableFooterView) {
		self.tableView.tableFooterView = nil;
	}
}

-(IBAction)reloadButton:(id)sender {
	NSLog(@"[%@]reload button clicked", [self className]);
	if (activeTwitterClient == nil) {
		[self getTimelineWithPage:0 autoload:NO];
	} else {
		[activeTwitterClient cancel];
	}
}

- (void)resetTimeline {
	[timeline removeAllObjects];
	[self removeLastReloadTime];
}

@end