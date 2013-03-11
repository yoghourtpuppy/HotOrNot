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
@synthesize vsImage = _vsImage;
@synthesize delegate=_delegate;
@synthesize name1 =_name1;
@synthesize name2 = _name2;

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
    [_vsImage release];
    [_name1 release];
    [_name2 release];
    [super dealloc];
}
- (IBAction)clickButton1:(id)sender {

    if([sender class] == [UIButton class]){

        [self.delegate button1Clicked:(UIButton*)sender inView:self];
      
    }
}

- (IBAction)clickButton2:(id)sender {
    if([sender class] == [UIButton class]){
        [self.delegate button2Clicked:(UIButton*)sender inView:self];
    }
}
@end
