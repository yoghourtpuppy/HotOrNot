//
//  SCsubview.m
//  HotOrNot
//
//  Created by Qing Chen on 3/8/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import "SCsubview.h"

@implementation SCsubview
@synthesize fButton1=_fButton1;
@synthesize fButton2=_fButton2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle]
                         loadNibNamed:@"subView"
                         owner:self
                         options:nil];
         self = [nib objectAtIndex:0];
        self.fButton1.tag = 1000;
        self.fButton2.tag = 1001;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_fButton2 release];
    [super dealloc];
}
@end
