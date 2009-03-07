#import "NTLNAccount.h"

#define NTLN_PREFERENCE_USERID				@"userId"
#define NTLN_PREFERENCE_PASSWORD			@"password"
#define NTLN_PREFERENCE_TWITTER_USERID		@"twitter_user_id"

static NTLNAccount *_instance;

@implementation NTLNAccount

@synthesize username, password, userId;

+ (id) instance {
    if (!_instance) {
        return [NTLNAccount newInstance];
    }
    return _instance;
}

+ (id) newInstance {
    if (_instance) {
        [_instance release];
        _instance = nil;
    }
    
    _instance = [[NTLNAccount alloc] init];
    return _instance;
}

- (void) dealloc {
	[username release];
	[password release];
	[userId release];
    [super dealloc];
}

//- (void)setUsername:(NSString*)username {
//    [[NSUserDefaults standardUserDefaults] setObject:username forKey:NTLN_PREFERENCE_USERID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void)setPassword:(NSString*)password {
//    [[NSUserDefaults standardUserDefaults] setObject:password forKey:NTLN_PREFERENCE_PASSWORD];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//- (void)setUserId:(NSString*)user_id {
//    [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:NTLN_PREFERENCE_TWITTER_USERID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//- (NSString*) username {
//	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_USERID];
//}
//
//- (NSString*) password {
//	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_PASSWORD];
//}
//
//- (NSString*) userId {
//	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_TWITTER_USERID];
//}

- (BOOL) valid {
	NSString *pwd = self.password;
	NSString *usn = self.username;
	return usn != nil && usn.length > 0 &&
			pwd != nil && pwd.length > 0;
}

- (void)retrieveUserId {
	NTLNTwitterUserClient *c = [[NTLNTwitterUserClient alloc] initWithDelegate:self];
	[c getUserInfoForScreenName:[self username]];
}

- (void)twitterUserClientSucceeded:(NTLNTwitterUserClient*)sender {
	[self setUserId:sender.user.user_id];
}

- (void)twitterUserClientFailed:(NTLNTwitterUserClient*)sender {
}

#pragma mark -
#pragma mark nscoding
- (void)encodeWithCoder:(NSCoder *)coder {
//	[super encodeWithCoder:coder];
	[coder encodeObject:username forKey:@"username"];
	[coder encodeObject:password forKey:@"password"];
	[coder encodeObject:userId forKey:@"userId"];
}

- (id)initWithCoder:(NSCoder *)coder {
//	self = [super initWithCoder:coder];
	if ([super init] == nil)
		return nil;
	self.username = [[coder decodeObjectForKey:@"username"] retain];
	self.password = [[coder decodeObjectForKey:@"password"] retain];
	self.userId = [[coder decodeObjectForKey:@"userId"] retain];
	return self;
}

@end
