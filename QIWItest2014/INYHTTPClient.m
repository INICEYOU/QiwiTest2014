//
//  INYHTTPClient.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYHTTPClient.h"
#import "SMXMLDocument.h"

@interface INYHTTPClient (){
    NSString *urlString;
}
@end

@implementation INYHTTPClient

- (void)RequestWithURL:(NSString*)url option:(NSString*)option
{
    NSString *URLfull = [url stringByAppendingString:option];
    NSLog(@"%@",URLfull);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLfull]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:15.0];
    urlString = url;
    // создаём соединение и начинаем загрузку
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        // соединение началось
        // создаем NSMutableData, чтобы сохранить полученные данные
        _receivedData = [NSMutableData data] ;
    } else {
        // при попытке соединиться произошла ошибка
    }

}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    // получен ответ от сервера
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    // добавляем новые данные к receivedData
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    // освобождаем соединение и полученные данные
    
    
    // выводим сообщение об ошибке
    NSString *errorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@ %@",
                             [error localizedDescription],
                             [error description],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
//    label.text = errorString;
    NSLog(@"%@",errorString);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // данные получены
    // здесь можно произвести операции с данными
    // можно узнать размер загруженных данных
    //NSString *dataString = [[NSString alloc] initWithFormat:@"Received %d bytes of data",[receivedData length]];
    // если ожидаемые полученные данные - это строка, то можно вывести её
    ////////////////////////////
    //  NSString *dataString = [[NSString alloc] initWithData:receivedData                                                 encoding:NSUTF8StringEncoding];
    //  label.text = dataString;
    
    
    NSError *error;
    SMXMLDocument *document = [SMXMLDocument documentWithData:_receivedData error:&error];
  //NSLog(@"Document:\n %@", document);
    
    
    
    //NSString *id = [user attributeNamed:@"id"];   //message
    int valueCode = [document valueWithPath:@"result-code"].intValue;
    NSLog(@"valueCode  %d", valueCode);
    
    if (valueCode == 0) {
        if ([urlString  isEqual: @"http://je.su/test"]) {
            
            SMXMLElement *users = [document childNamed:@"users"];
            for (SMXMLElement *user in [users childrenNamed:@"user"]) {
                _idUser = [user attributeNamed:@"id"];
                _name = [user attributeNamed:@"name"];
                _secondName = [user attributeNamed:@"second-name"];
            }
            ///TEMP
            _idUser = @"7";
            _name = @"name";
            _secondName = @"second-name";
            ///
            NSLog(@"user ID %@ NAME %@ SNAME %@",_idUser,_name,_secondName);
        }
        else {
            SMXMLElement *balances = [document childNamed:@"balances"];
            for (SMXMLElement *balance in [balances childrenNamed:@"balance"]) {
                _currency = [balance attributeNamed:@"currency"];
                float amount = [balance attributeNamed:@"amount"].floatValue;
                
                _money = [balance attributeNamed:@"amount"];
                
                [[NSNumberFormatter new] setInternationalCurrencySymbol:_currency];
                NSLog(@"user  %@", _currency );
                NSLog(@"user  %.2f", amount);
            }
        }
        ///TEMP
        _money = @"777";
        _currency = @"USD";
        NSLog(@"balance  %@  %@",_money,_currency);
        ///
        
    } else {
        SMXMLElement *codeResult = [document childNamed:@"result-code"];
        NSString *codeMessage = [codeResult attributeNamed:@"message"];
        NSLog(@"user  %@", codeMessage);
    }
    // освобождаем соединение и полученные данные
}

@end
