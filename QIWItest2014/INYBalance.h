//
//  INYBalance.h
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INYBalance : NSObject

@property (strong, nonatomic) NSString *idUser, *balance, *currency;

- (id)initWithId:(NSString *)idUser
         balance:(NSString *)balance
        currency:(NSString *)currency;

@end
