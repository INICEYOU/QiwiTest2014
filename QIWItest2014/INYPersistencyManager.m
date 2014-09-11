//
//  INYPersistencyManager.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYPersistencyManager.h"
#import "INYUsers.h"
#import "INYBalance.h"

@interface INYPersistencyManager ()
{
    NSMutableArray * users; // Массив всех
    NSMutableArray * balances;
}
@end

@implementation INYPersistencyManager

- (id)init
{
    self = [super init];
    if (self)
    {
        users = [NSMutableArray arrayWithArray:
                  @[[[INYUsers alloc] initWithId:@"1" name:@"Vanya" secondName:@"Sedoy"],
                    [[INYUsers alloc] initWithId:@"2" name:@"Vanya2" secondName:@"Sedoy2"],
                    [[INYUsers alloc] initWithId:@"3" name:@"Vanya3" secondName:@"Sedoy3"]
                    ]];
        balances = [NSMutableArray arrayWithArray:
                  @[[[INYBalance alloc] initWithId:@"1" balance:@"222" currency:@"USD"],
                    [[INYBalance alloc] initWithId:@"2" balance:@"131" currency:@"RUB"]
                    ]];
    }
    return self;
}

- (NSArray *)getUsers
{
    return users;
}

- (NSArray *)getBalances
{
    return balances;
}

@end
