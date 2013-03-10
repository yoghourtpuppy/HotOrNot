//
//  SCselectedFriend.h
//  HotOrNot
//
//  Created by Qing Chen on 3/9/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCselectedFriend : NSObject
@property(copy) NSString *fid;
@property(copy) NSString *name;
@property(assign) int count;

- (id)initWithId:(NSString*)fid name:(NSString*)name count:(int)count;

@end
