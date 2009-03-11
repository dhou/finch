#import <UIKit/UIKit.h>
#import "NTLNTwitterClient.h"

@class NTLNAppDelegate;

@interface NTLNTweetPostViewController : UIViewController <UITextViewDelegate, NTLNTwitterClientDelegate> {
	UITextView *tweetTextView;
	UILabel *textLengthView;

	NSString *backupFilename;
	UIView *superView;
	BOOL active;
	
	NSString *tmpTextForInitial;
}

@property (readonly) BOOL active;
@property (retain) NSString *tmpTextForInitial;

- (void)setSuperView:(UIView*)view;

- (IBAction)closeButtonPushed:(id)sender;
- (IBAction)sendButtonPushed:(id)sender;
- (IBAction)clearButtonPushed:(id)sender;

- (void)createReplyPost:(NSString*)text;
- (void)createDMPost:(NSString*)reply_to;

//- (void)showWindow;
- (void)closeWindow;

@end
