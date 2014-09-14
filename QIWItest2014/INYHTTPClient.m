//
//  INYHTTPClient.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYHTTPClient.h"
#import "INYLibraryAPI.h"


@interface INYHTTPClient (){
    NSString *urlString;
    NSString *optionIdUser;
}
@end

@implementation INYHTTPClient

- (void)RequestWithURL:(NSString*)url option:(NSString*)option
{
    NSString *URLfull = [url stringByAppendingString:option];
    NSLog(@"%@",URLfull);
    
    NSURLRequest *request = [NSURLRequest new];
    
    if ([url isEqualToString:@"http://je.su/test"]) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLfull]
                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                timeoutInterval:15.0];
    } else {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLfull]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                timeoutInterval:15.0];
    }
    
    urlString = url;
    optionIdUser = option;
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {

        _receivedData = [NSMutableData data] ;
    }
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    NSString *errorString = [[NSString alloc] initWithFormat:@"Connection failed! %@",
                             [error localizedDescription]];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                    message:errorString
                                                   delegate:self
                                          cancelButtonTitle:@"Ок"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [[INYLibraryAPI sharedInstance]getWithReceivedData:_receivedData urlString:urlString optionIdUser:optionIdUser];
    
    if ([urlString isEqualToString:@"http://je.su/test"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUsersViewAfterConnection" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBalanceViewAfterConnection" object:nil];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSMutableDictionary *mutableUserInfo = [[cachedResponse userInfo] mutableCopy];
    NSMutableData *mutableData = [[cachedResponse data] mutableCopy];
    NSURLCacheStoragePolicy storagePolicy = NSURLCacheStorageAllowed;
    
    return [[NSCachedURLResponse alloc] initWithResponse:[cachedResponse response]
                                                    data:mutableData
                                                userInfo:mutableUserInfo
                                           storagePolicy:storagePolicy];
}

@end
