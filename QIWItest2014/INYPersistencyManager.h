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

- (NSArray *)getUsers;
- (NSArray *)getBalances;

- (NSString *)getUserIdWithIndex:(NSIndexPath*)index;
- (NSArray *)getBalanceWithUserId:(NSString*)idUser;
- (NSString *)getBalanceUserFriendlyWithBalance:(INYBalance*)inybalance;

@end
