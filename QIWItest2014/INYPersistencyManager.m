//
//  INYPersistencyManager.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYPersistencyManager.h"
#import "INYUsers.h"

@interface INYPersistencyManager ()
{
    NSMutableArray * users; // Массив всех альбомов
}
@end

@implementation INYPersistencyManager

- (id)init
{
    self = [super init];
    if (self)
    {
        users = [NSMutableArray arrayWithArray:
                  @[[[INYUsers alloc] initWithId:@"111" name:@"Vanya" secondName:@"Sedoy"],
                    [[INYUsers alloc] initWithId:@"222" name:@"Vanya2" secondName:@"Sedoy2"],
                    [[INYUsers alloc] initWithId:@"333" name:@"Vanya3" secondName:@"Sedoy3"]
                    ]];
    }
    return self;
}

- (NSArray *)getUsers
{
    return users;
}

@end
