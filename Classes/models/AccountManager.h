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
	NSInteger currentAccountIndex;
}

@property (retain) NSMutableArray *accountsList;
@property (nonatomic, copy) NSString *currentDirectoryPath;
@property (nonatomic, assign) NSInteger currentAccountIndex;

- (void)addAccount:(NTLNAccount *) account;
- (void)removeAccountAtIndex:(NSInteger) index;
- (NTLNAccount *)getAccountAtIndex:(NSInteger) index;
- (NSInteger)countOfAccounts;
- (void)loadAccounts;
- (void)saveAccounts;
- (NTLNAccount *)currentAccount;

+ (AccountManager *)sharedInstance;

@end
