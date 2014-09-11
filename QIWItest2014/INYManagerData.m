//
//  INYManagerData.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYManagerData.h"
#import "SMXMLDocument.h"

@interface INYManagerData ()

-(id)initWithData:(NSMutableData*)receivedData;

//Id:(NSString *)userID userName:(NSString *)userName userSecondName:(NSString*)userSecondName;

@end

@implementation INYManagerData

-(id)initWithData:(NSMutableData *)receivedData{
    self = [super init];
    if (self)
    {
        NSError *error;
        SMXMLDocument *document = [SMXMLDocument documentWithData:receivedData error:&error];
        
        int valueCode = [document valueWithPath:@"result-code"].intValue;

        SMXMLElement *balances = [document childNamed:@"balances"];
        for (SMXMLElement *balance in [balances childrenNamed:@"balance"]) {
            NSString *currency = [balance attributeNamed:@"currency"];
            float amount = [balance attributeNamed:@"amount"].floatValue;
            
            [[NSNumberFormatter new] setInternationalCurrencySymbol:currency];
            NSLog(@"user  %@", currency );
            NSLog(@"user  %.2f", amount);
            //getMoneyUserId = idUser;
            //NSLog(@"user  %@", [ULRgetMoneyWithUserId stringByAppendingString:getMoneyUserId]);
        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        _receivedData = receivedData;
        

    }
    return self;
}

@end
