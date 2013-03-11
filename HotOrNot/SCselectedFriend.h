//
//  SCselectedFriend.h
//  HotOrNot
//
//  class that stores selected friends' name, id and pts
//  Created by Qing Chen on 3/9/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCselectedFriend : NSObject
@property(copy) NSString *fid;//id
@property(copy) NSString *name;//name
@property(assign) int count;//the pts

- (id)initWithId:(NSString*)fid name:(NSString*)name count:(int)count;

@end
