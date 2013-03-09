//
//  SCsubview.m
//  HotOrNot
//
//  Created by Qing Chen on 3/8/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import "SCsubview.h"

@implementation SCsubview

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
    }
    return self;
}

- (void)setupThisSubView:(NSString *) labelText
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
