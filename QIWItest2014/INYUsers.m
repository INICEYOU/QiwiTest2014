//
//  INYUsers.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYUsers.h"
#import "SMXMLDocument.h"

@interface INYUsers ()

-(id)initWithData:(NSMutableData*)receivedData;

//Id:(NSString *)userID userName:(NSString *)userName userSecondName:(NSString*)userSecondName;

@end

@implementation INYUsers

-(id)initWithData:(NSMutableData *)receivedData{
    self = [super init];
    if (self)
    {
        NSError *error;
        SMXMLDocument *document = [SMXMLDocument documentWithData:receivedData error:&error];
        
        
        
        _userId = @"1";
        _userName = @"2";
        _userSecondName = @"3";
    }
    return self;
}


@end
