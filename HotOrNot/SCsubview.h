//
//  SCsubview.h
//  HotOrNot
//
//  The subview that display options
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
@property (retain, nonatomic) IBOutlet UIImageView *vsImage;
@property (retain, nonatomic) IBOutlet UILabel *name1;
@property (retain, nonatomic) IBOutlet UILabel *name2;
- (IBAction)clickButton1:(id)sender;
- (IBAction)clickButton2:(id)sender;
@property(nonatomic,assign)id<viewWithButtonDelegate> delegate;
@end
