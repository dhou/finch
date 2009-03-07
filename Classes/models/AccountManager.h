//
//  AccountManager.h
//  ntlniph
//
//  Created by houyr on 09-3-6.
//  Copyright 2009 marsbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTLNAccount;

@interface AccountManager : NSObject {
	NSMutableArray *accountsList;
	NSString *currentDirectoryPath;
}

@property (retain) NSMutableArray *accountsList;
@property (nonatomic, copy) NSString *currentDirectoryPath;

- (void)addAccount:(NTLNAccount *) account;
- (NSInteger)countOfAccounts;
- (void)loadAccounts;
- (void)saveAccounts;
+ (AccountManager *)sharedInstance;

@end
