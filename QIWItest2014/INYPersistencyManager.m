//
//  INYPersistencyManager.m
//  QIWItest2014
//
//  Created by Nice on 11/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYPersistencyManager.h"

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
        albums = [NSMutableArray arrayWithArray:
                  @[[[Album alloc] initWithTitle:@"Best of Bowie"
                                          artist:@"David Bowie"
                                        coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png"
                                            year:@"1992"],
                    
                    [[Album alloc] initWithTitle:@"It's My Life"
                                          artist:@"No Doubt"
                                        coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png"
                                            year:@"2003"],
                    
                    [[Album alloc] initWithTitle:@"Nothing Like The Sun"
                                          artist:@"Sting"
                                        coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png"
                                            year:@"1999"],
                    
                    [[Album alloc] initWithTitle:@"Staring at the Sun"
                                          artist:@"U2"
                                        coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png"
                                            year:@"2000"],
                    
                    [[Album alloc] initWithTitle:@"American Pie"
                                          artist:@"Madonna"
                                        coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png"
                                            year:@"2000"]]];
    }
    return self;
}

- (NSArray *)getUsers
{
    return users;
}

@end
