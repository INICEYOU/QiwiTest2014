//
//  INYHTTPClient.h
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INYHTTPClient : NSObject

@property (strong, nonatomic) NSMutableData *receivedData;

@property (strong, nonatomic) NSString *idUser;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *secondName;

@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSString *money;

- (void)RequestWithURL:(NSString*)url option:(NSString*)option;

@end
