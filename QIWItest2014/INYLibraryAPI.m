//
//  INYLibraryAPI.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYLibraryAPI.h"
#import "INYUsers.h"
#import "INYBalance.h"
#import "INYHTTPClient.h"
#import "INYPersistencyManager.h"

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
    return [persistencyManager getUsers];
}

@end