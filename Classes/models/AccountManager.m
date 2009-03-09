//
//  AccountManager.m
//  ntlniph
//
//  Created by houyr on 09-3-6.
//  Copyright 2009 marsbug. All rights reserved.
//

#import "AccountManager.h"
#import "NTLNAccount.h"

@implementation AccountManager

@synthesize accountsList, currentDirectoryPath, currentAccountIndex;

static AccountManager *_instance;

+ (AccountManager *)sharedInstance {
	@synchronized(self) {
		if (!_instance ) {
			_instance = [[AccountManager alloc] init];
		}
	}
	return _instance;
}

- (id)init {
	if(self = [super init]) {
//		accountsList = [[NSMutableArray alloc] init];
		// Set current directory for Finch
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		self.currentDirectoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"finch"];
		
		BOOL isDir;
		if (![fileManager fileExistsAtPath:self.currentDirectoryPath isDirectory:&isDir] || !isDir) {
			[fileManager createDirectoryAtPath:self.currentDirectoryPath attributes:nil];
		}
		// set the current dir
		[fileManager changeCurrentDirectoryPath:self.currentDirectoryPath];
		
		[self loadAccounts];
	}
	return self;
}

- (void) dealloc {
	[accountsList release];
	[super dealloc];
}

- (void)addAccount:(NTLNAccount *) account {
	NSLog(@"adding account for: %@", [account username]);
	[accountsList addObject:account];
	NSLog(@"Now has %d accounts", [accountsList count]);
}

- (void)removeAccountAtIndex:(NSInteger) index {
	if(index < [self countOfAccounts]){
		[[self accountsList] removeObjectAtIndex:index];
	}
}

- (NTLNAccount *)getAccountAtIndex:(NSInteger) index{
	if(index < [accountsList count]) {
		return [accountsList objectAtIndex:index];
	} else {
		return nil;
	}
}

- (NSInteger)countOfAccounts {
	return [accountsList count];
}

- (NTLNAccount *)currentAccount {
	return [accountsList objectAtIndex:currentAccountIndex];
}

// loads saved accounts
-(void)loadAccounts {
	NSLog(@"AccountManager loading accounts");
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *accountsArchivePath = [currentDirectoryPath stringByAppendingPathComponent:@"finch.accounts.archive"];
	NSLog(@"AccountManager load archive path: %@", accountsArchivePath);
	
	if ([fileManager fileExistsAtPath:accountsArchivePath]) {
		// set method will release, make mutable copy and retain
		NSMutableArray *arr = [[NSKeyedUnarchiver unarchiveObjectWithFile:accountsArchivePath] mutableCopy];
		self.accountsList = arr;
		[arr release];
	} else{
		self.accountsList = [NSMutableArray array];
		[self saveAccounts];
	}
	NSLog(@"AccountManager loaded %d accounts from archive", [self.accountsList count]);
	NTLNAccount *a = [self getAccountAtIndex:0];
	NSLog(@"AccountManager first account from archive: %@", a.username);
//	[a release];
}

- (void)saveAccounts {
	NSLog(@"AccountManager saving accounts data");
	NSString *accountsFilePath = [currentDirectoryPath stringByAppendingPathComponent:@"finch.accounts.archive"];
	NSLog(@"Archive path: %@", accountsFilePath);
	if ([accountsList count] || ([[NSFileManager defaultManager] fileExistsAtPath:accountsFilePath])) {
		[NSKeyedArchiver archiveRootObject:accountsList toFile:accountsFilePath];
	} else {
		NSLog(@"No account in list. there is nothing to save!");
	}
}

@end
