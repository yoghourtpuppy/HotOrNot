//
//  SCselectedFriend.m
//  HotOrNot
//
//  Created by Qing Chen on 3/9/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import "SCselectedFriend.h"

@implementation SCselectedFriend
@synthesize fid=_fid;
@synthesize name=_name;
@synthesize count=_count;

- (id)initWithId:(NSString *)fid name:(NSString *)name count:(int)count{
    if((self = [super init])){
        self.fid = fid;
        self.name = name;
        self.count = count;
    }
    return self;
}

@end
