//
//  INYUser.h
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INYUser : NSObject

@property (strong, nonatomic) NSString *idUser;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *secondName;

- (id)initWithId:(NSString *)idUser
            name:(NSString *)name
      secondName:(NSString *)secondName;
@end
