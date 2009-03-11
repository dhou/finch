#import <UIKit/UIKit.h>
#import "NTLNTwitterUserClient.h"
#import "Constants.h"

@interface NTLNAccount : NSObject<NTLNTwitterUserClientDelegate, NSCoding> {
	NSString *username;
	NSString *password;
	NSString *userId;
	NSString *type;
}

@property (retain) NSString *username;
@property (retain) NSString *password;
@property (retain) NSString *userId;
@property (assign) NSString *type;

+ (id) instance;
+ (id) newInstance;

//- (NSString*) username;
//- (NSString*) password;
//- (NSString*) userId;
//
//- (void)setUsername:(NSString*)username;
//- (void)setPassword:(NSString*)password;
	
- (BOOL) valid;

- (void)retrieveUserId;

@end


