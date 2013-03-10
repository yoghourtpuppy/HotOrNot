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
@synthesize delegate=_delegate;
@synthesize flag1 = _flag1;
@synthesize flag2 = _flag2;

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
    [_fButton1 release];
    [super dealloc];
}
- (IBAction)clickButton1:(id)sender {
    
    if([sender class] == [UIButton class]){
        [self.delegate button1Clicked:(UIButton*)sender inView:self];
        NSLog(@"the button1 is clicked");
    }
}

- (IBAction)clickButton2:(id)sender {
    if([sender class] == [UIButton class]){
        [self.delegate button2Clicked:(UIButton*)sender inView:self];
        NSLog(@"the button2 is clicked");
    }
}
@end
