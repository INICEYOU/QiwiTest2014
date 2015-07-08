//
//  INYLibraryAPI.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYLibraryAPI.h"
#import "INYPersistencyManager.h"
#import "INYHTTPClient.h"



@interface INYLibraryAPI ()
{
    INYPersistencyManager *persistencyManager;
    INYHTTPClient *httpClient;
}
@end

@implementation INYLibraryAPI

- (id)init
{
    self = [super init];
    if (self)
    {
        persistencyManager = [[INYPersistencyManager alloc] init];
        httpClient = [[INYHTTPClient alloc] init];
    }
    return self;
}

+ (INYLibraryAPI *)sharedInstance
{
    
    static INYLibraryAPI * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[INYLibraryAPI alloc] init];
    });
    return _sharedInstance;
}

- (NSArray *)users
{
    return [persistencyManager users];
}

- (NSArray *)balances
{
    return [persistencyManager balances];
}

- (NSString *)userIdWithIndex:(NSIndexPath *)index
{
    return [persistencyManager userIdWithIndex:index];
}

- (NSArray *)balanceWithUserId:(NSString*)idUser
{
    return [persistencyManager balanceWithUserId:idUser];
}

- (NSString *)balanceUserFriendlyWithBalance:(INYBalance*)inybalance
{
    return [persistencyManager balanceUserFriendlyWithBalance:inybalance];
}

- (void)requestWithURL:(NSString*)url option:(NSString*)option
{
    [httpClient requestWithURL:url option:option];
}

- (void)withReceivedData:(NSData*)receivedData urlString:(NSString*)urlString optionIdUser:(NSString*)optionIdUser
{
    [persistencyManager
     withReceivedData:receivedData urlString:urlString optionIdUser:optionIdUser];
}

- (NSString *)codeMessageRequest{
   return [persistencyManager codeMessageRequest];
}

@end
