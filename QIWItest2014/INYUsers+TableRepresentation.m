//
//  INYUsers+TableRepresentation.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYUsers+TableRepresentation.h"

@implementation INYUsers (TableRepresentation)

- (NSDictionary *)tr_tableRepresentation
{
    return @{@"titles":@[@"Пользователь", @"Имя", @"Фамилия"],
             @"values":@[self.idUser, self.name, self.secondName]};
}

@end
