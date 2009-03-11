#import "ntlniphAppDelegate.h"
#import "NTLNAccount.h"
#import "NTLNTweetPostViewController.h"
#import "NTLNFriendsViewController.h"
#import "NTLNReplysViewController.h"
#import "NTLNSentsViewController.h"
#import "NTLNUnreadsViewController.h"
#import "NTLNConfigViewController.h"
#import "NTLNCacheCleaner.h"
#import "NTLNBrowserViewController.h"
#import "AccountManager.h"

@implementation NTLNAppDelegate

@synthesize window;
@synthesize tabBarController, navController;
@synthesize applicationActive;
@synthesize browserViewController;
@synthesize tweetPostViewController;

- (void)createViews {
	tweetPostViewController = [[NTLNTweetPostViewController alloc] 
									initWithNibName:@"TweetView" bundle:nil];
//	[tweetPostViewController setSuperView:tabBarController.view];
	
	browserViewController = [[NTLNBrowserViewController alloc] init];

	friendsViewController = [[NTLNFriendsViewController alloc] init];
	replysViewController = [[NTLNReplysViewController alloc] init];
	sentsViewController = [[NTLNSentsViewController alloc] init];
	unreadsViewController = [[NTLNUnreadsViewController alloc] init];
	
	unreadsViewController.friendsViewController = friendsViewController;
	unreadsViewController.replysViewController = replysViewController;
	
	friendsViewController.appDelegate = self;
	friendsViewController.tweetPostViewController = tweetPostViewController;
	replysViewController.appDelegate = self;
	replysViewController.tweetPostViewController = tweetPostViewController;
	sentsViewController.appDelegate = self;
	sentsViewController.tweetPostViewController = tweetPostViewController;
	unreadsViewController.appDelegate = self;
	unreadsViewController.tweetPostViewController = tweetPostViewController;
	
	
//	configViewController = [[NTLNConfigViewController alloc] initWithNibName:@"ConfigView" bundle:nil];
	configViewController = [[NTLNConfigViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	UINavigationController *nfri = [[[UINavigationController alloc] 
										initWithRootViewController:friendsViewController] autorelease];
	UINavigationController *nrep = [[[UINavigationController alloc] 
										initWithRootViewController:replysViewController] autorelease];
	UINavigationController *nsen = [[[UINavigationController alloc] 
										initWithRootViewController:sentsViewController] autorelease];
	UINavigationController *nunr = [[[UINavigationController alloc] 
										initWithRootViewController:unreadsViewController] autorelease];
//	UINavigationController *nset = [[[UINavigationController alloc] 
//										initWithRootViewController:configViewController] autorelease];
	
//	[tabBarController setViewControllers:
//		[NSArray arrayWithObjects:friendsViewController, replysViewController, sentsViewController, unreadsViewController, nil]];
	[tabBarController setViewControllers:
	 [NSArray arrayWithObjects:nfri, nrep, nsen, nunr, nil]];
//	[tabBarController navigationItem].titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friends.png"]];
	
	navController = [[UINavigationController alloc] initWithRootViewController:configViewController];
	[navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	
//	[nfri.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	[nfri.tabBarItem setTitle:@"Friends"];
	[nfri.tabBarItem setImage:[UIImage imageNamed:@"friends.png"]];
//	friendsViewController.tabBarItem = nfri.tabBarItem; // is it need (to show badge)?
//	friendsViewController.tabBarItem.image = [UIImage imageNamed:@"friends.png"];
//	friendsViewController.tabBarItem.title = @"Friends";
//	
//	[nrep.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	[nrep.tabBarItem setTitle:@"Replies"];
	[nrep.tabBarItem setImage:[UIImage imageNamed:@"replies.png"]];
//	replysViewController.tabBarItem  = nrep.tabBarItem; // is it need (to show badge)?
//	replysViewController.tabBarItem.image = [UIImage imageNamed:@"replies.png"];
//	replysViewController.tabBarItem.title = @"Replies";
//
//	[nsen.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	[nsen.tabBarItem setTitle:@"Sents"];
	[nsen.tabBarItem setImage:[UIImage imageNamed:@"sent.png"]];
//	sentsViewController.tabBarItem.image = [UIImage imageNamed:@"sent.png"];
//	sentsViewController.tabBarItem.title = @"Sents";
//
//	[nunr.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	[nunr.tabBarItem setTitle:@"Unreads"];
	[nunr.tabBarItem setImage:[UIImage imageNamed:@"unread.png"]];
//	unreadsViewController.tabBarItem.image = [UIImage imageNamed:@"unread.png"];
//	unreadsViewController.tabBarItem.title = @"Unreads";
	
//	[nset.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
//	[nset.tabBarItem setTitle:@"Settings"];
//	[nset.tabBarItem setImage:[UIImage imageNamed:@"setting.png"]];
}

- (void)startup {
	[self createViews];
	
//	if ([[NTLNAccount instance] valid]) {	
		//TODO: use last used account and push the friends view upon startup
//		NSLog(@"got saved account: %@", [[NTLNAccount instance] username]);
//		[navController pushViewController:tabBarController animated:YES];
//		tabBarController.selectedIndex = 0; // friends view
//	}
	
//	NSString *user_id = [[NTLNAccount instance] userId];
//	if (user_id == nil || [user_id length] == 0) {
//		[[NTLNAccount instance] retrieveUserId];
//	}
	
	[window addSubview:navController.view];
	[window makeKeyAndVisible];
	
	applicationActive = TRUE;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NTLNCacheCleaner *cc = [NTLNCacheCleaner sharedCacheCleaner];
	cc.delegate = self;
	BOOL alertShown = [cc bootup];
	if (!alertShown) {
		[self startup];
	}
}

- (void)cacheCleanerAlertClosed {
	[self startup];
}

- (void)dealloc {
	[friendsViewController release];
	[replysViewController release];
	[sentsViewController release];
	[unreadsViewController release];
	[configViewController release];
	[browserViewController release];
	[tweetPostViewController release];
	
	[tabBarController release];
	[navController release];
	[window release];
	[super dealloc];
}

- (void)resetTimelines {
	[friendsViewController resetTimeline];
	[replysViewController resetTimeline];
	[sentsViewController resetTimeline];
	[unreadsViewController resetTimeline];
}

- (void)showTweetView {
	[navController presentModalViewController:tweetPostViewController animated:YES];
}

- (void)tabBarController:(UITabBarController *)tabBarController 
			didSelectViewController:(UIViewController *)viewController {
	NSLog(@"view selected: %@", [[viewController tabBarItem] title]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"applicationWillResignActive");
	applicationActive = FALSE;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"applicationDidBecomeActive");
	applicationActive = TRUE;
	[friendsViewController getTimelineWithPage:0 autoload:YES];
	[replysViewController getTimelineWithPage:0 autoload:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"applicationWillTerminate");
	[[NTLNCacheCleaner sharedCacheCleaner] shutdown];
	[[AccountManager sharedInstance] saveAccounts];
}

@end
