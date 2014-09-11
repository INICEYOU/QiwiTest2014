//
//  INYBalance.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYBalance.h"

@implementation INYBalance

- (id)initWithId:(NSString *)idBalance
         balance:(NSString *)balance
        currency:(NSString *)currency
{
    self = [super init];
    if (self)
    {
        _idBalance = idBalance;
        _balance = balance;
        _currency = currency;
    }
    return self;
}
@end
