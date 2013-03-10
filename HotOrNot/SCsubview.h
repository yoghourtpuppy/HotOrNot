//
//  SCsubview.h
//  HotOrNot
//
//  Created by Qing Chen on 3/8/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAppDelegate.h"

@interface SCsubview : UIView{
    id<viewWithButtonDelegate> delegate;
}
@property (retain, nonatomic) IBOutlet UIButton *fButton1;
@property (retain, nonatomic) IBOutlet UIButton *fButton2;
- (IBAction)clickButton1:(id)sender;
- (IBAction)clickButton2:(id)sender;
@property(nonatomic,assign)id<viewWithButtonDelegate> delegate;
@property(assign) int flag1;
@property(assign) int flag2;
@end
