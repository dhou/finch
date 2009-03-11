#import "NTLNTimelineViewController.h"
#import "NTLNCache.h"
#import "NTLNTwitterXMLReader.h"
#import "NTLNAccount.h"
#import "AccountManager.h"

@implementation NTLNTimelineViewController(Cache)

#pragma mark Private

- (void)loadCacheWithFilename:(NSString*)fn{
	NSLog(@"timeline view loading cache from %@", fn);
	NSData *data = [NTLNCache loadWithFilename:fn];
	if (data) {
		NTLNTwitterXMLReader *xr = [[NTLNTwitterXMLReader alloc] init];
		[xr parseXMLData:data];
		[self twitterClientSucceeded:nil messages:xr.messages];
		[xr release];
	}
}

- (void)loadCache {
	[self loadCacheWithFilename:xmlCachePath];
}

- (void)saveCache:(NTLNTwitterClient*)sender filename:(NSString*)filename {
	[NTLNCache saveWithFilename:filename data:sender.recievedData];
}

- (void)saveCache:(NTLNTwitterClient*)sender {
	NSLog(@"saving cache to %@", xmlCachePath);
	[self saveCache:sender filename:xmlCachePath];
}

- (void)initialCacheLoading:(NSString*)name {
	NTLNAccount *curAccount = [[AccountManager sharedInstance] currentAccount];
	xmlCachePath = [[NTLNCache createXMLCacheDirectory] stringByAppendingString:[NSString stringWithFormat:@"%@_%@_%@", curAccount.type, curAccount.username, name]];
	NSLog(@"initial cache loading from: %@", xmlCachePath);
	[xmlCachePath retain];
	[self loadCache];
}

- (void)initialCacheLoading {
}


@end