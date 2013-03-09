//
//  SCsubview.h
//  HotOrNot
//
//  Created by Qing Chen on 3/8/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAppDelegate.h"

@interface SCsubview : UIView
@property (retain, nonatomic) IBOutlet UIButton *fButton1;
@property(nonatomic,assign)id<SCAppDelegate> delegate;

@end
