//
//  INYPersistencyManager.h
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INYBalance.h"

@interface INYPersistencyManager : NSObject

- (NSArray *)users;
- (NSArray *)balances;

- (NSString *)userIdWithIndex:(NSIndexPath *)index;
- (NSArray *)balanceWithUserId:(NSString *)idUser;
- (NSString *)balanceUserFriendlyWithBalance:(INYBalance *)inybalance;

- (void)withReceivedData:(NSData *)receivedData urlString:(NSString *)urlString optionIdUser:(NSString *)optionIdUser;
- (NSString *)codeMessageRequest;


@end
