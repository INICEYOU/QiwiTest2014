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
    BOOL isOnline;
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
        isOnline = NO;
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

- (NSArray *)getUsers
{
    /*
    if (isOnline)
    {
        
    }
    */
    return [persistencyManager getUsers];
}

- (NSArray *)getBalances
{
    /*
     if (isOnline)
     {
     
     }
     */
    return [persistencyManager getBalances];
}

- (NSString *)getUserIdWithIndex:(NSIndexPath*)index
{
    return [persistencyManager getUserIdWithIndex:index];
}

- (NSArray *)getBalanceWithUserId:(NSString*)idUser
{
    return [persistencyManager getBalanceWithUserId:idUser];
}

- (NSString *)getBalanceUserFriendlyWithBalance:(INYBalance*)inybalance
{
    return [persistencyManager getBalanceUserFriendlyWithBalance:inybalance];
}

@end
