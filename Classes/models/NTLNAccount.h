#import <UIKit/UIKit.h>
#import "NTLNTwitterUserClient.h"

@interface NTLNAccount : NSObject<NTLNTwitterUserClientDelegate, NSCoding> {
	NSString *username;
	NSString *password;
	NSString *userId;
}

@property (retain) NSString *username;
@property (retain) NSString *password;
@property (retain) NSString *userId;

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


