//
//  INYUsers.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYUsers.h"

@implementation INYUsers

- (id)initWithId:(NSString *)idUser
            name:(NSString *)name
      secondName:(NSString *)secondName
{
    self = [super init];
    if (self)
    {
        _idUser = idUser;
        _name = name;
        _secondName = secondName;
    }
    return self;
}


@end
