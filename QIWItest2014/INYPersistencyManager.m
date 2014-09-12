//
//  INYPersistencyManager.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYPersistencyManager.h"
#import "SMXMLDocument.h"
#import "INYUsers.h"


@interface INYPersistencyManager ()
{
    NSMutableArray * users; // Массив всех
    NSMutableArray * balances;
    NSString *codeMessageRequest;
}
@end

@implementation INYPersistencyManager

- (id)init
{
    self = [super init];
    if (self)
    {
        users = [NSMutableArray new];
        balances = [NSMutableArray new];
        codeMessageRequest = @"";
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

- (NSString *)getUserIdWithIndex:(NSIndexPath*)index
{
    INYUsers *myUser = users[index.row];
    return myUser.idUser;
}

- (NSArray *)getBalanceWithUserId:(NSString*)idUser
{
    NSMutableArray *myBalance = [NSMutableArray new];
    for (INYBalance *balance in balances) {
        if ([balance.idUser isEqual: idUser]){
            [myBalance addObject:balance];
        }
    }
    return myBalance;
}

-(NSString *)getBalanceUserFriendlyWithBalance:(INYBalance*)inybalance
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[self findLocaleByCurrencyCode:inybalance.currency]];
    [formatter setCurrencyCode:inybalance.currency];
    NSString *currencyString = [formatter stringFromNumber:@([inybalance.amount floatValue])];
    return currencyString;
}

- (NSLocale *) findLocaleByCurrencyCode:(NSString *)_currencyCode
{
    NSArray *locales = [NSLocale availableLocaleIdentifiers];
    NSLocale *locale = nil;
    NSString *localeId;
    
    for (localeId in locales) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeId] ;
        NSString *code = [locale objectForKey:NSLocaleCurrencyCode];
        if ([code isEqualToString:_currencyCode])
            break;
        else
            locale = nil;
    }
    
    if (locale == nil) {
        NSDictionary *components = [NSDictionary dictionaryWithObject:_currencyCode
                                                               forKey:NSLocaleCurrencyCode];
        
        localeId = [NSLocale localeIdentifierFromComponents:components];
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeId];
    }
    return locale;
}

- (void)getWithReceivedData:(NSData*)receivedData urlString:(NSString*)urlString optionIdUser:(NSString*)optionIdUser
{
    NSError *error;
    SMXMLDocument *document = [SMXMLDocument documentWithData:receivedData error:&error];
    NSLog(@"Document:\n %@", document);
    
    NSString *codeMessage = @"";
    
    //NSString *id = [user attributeNamed:@"id"];   //message
    int valueCode = [document valueWithPath:@"result-code"].intValue;
    NSLog(@"valueCode  %d", valueCode);
    
    if(![urlString  isEqualToString: @"http://je.su/test"]){
        NSMutableArray *newBalances = [NSMutableArray new];
        
        SMXMLElement *balancesElement = [document childNamed:@"balances"];
        for (SMXMLElement *balance in [balancesElement childrenNamed:@"balance"]) {
            INYBalance *currentBalance = [INYBalance new];
            currentBalance.currency = [balance attributeNamed:@"currency"];
            currentBalance.amount = [balance attributeNamed:@"amount"];
            currentBalance.idUser = optionIdUser;
            [newBalances addObject:currentBalance];
            NSLog(@"%@",currentBalance.currency);
        }
        balances = newBalances;
    }
    
    if (valueCode == 0) {
        if ([urlString  isEqualToString: @"http://je.su/test"]) {
            
            NSMutableArray *newUsers = [NSMutableArray new];
            
            SMXMLElement *usersElement = [document childNamed:@"users"];
            for (SMXMLElement *user in [usersElement childrenNamed:@"user"]) {
                INYUsers *curreentUser = [INYUsers new];
                curreentUser.idUser = [user attributeNamed:@"id"];
                curreentUser.name = [user attributeNamed:@"name"];
                curreentUser.secondName = [user attributeNamed:@"second-name"];
                [newUsers addObject:curreentUser];
            }
            users = newUsers;
        }
    } else {
        SMXMLElement *codeResult = [document childNamed:@"result-code"];
        codeMessage = [codeResult attributeNamed:@"message"];
        NSLog(@"user  %@", codeMessage);
    }
    codeMessageRequest = codeMessage;
}

- (NSString *)codeMessageRequest
{
    return codeMessageRequest;
}

@end
