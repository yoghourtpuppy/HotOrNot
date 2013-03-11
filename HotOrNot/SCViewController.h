//
//  SCViewController.h
//  HotOrNot
//
//  Created by Qing Chen on 3/6/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SCsubview.h"
@class SCsubview;
@interface SCViewController : UIViewController<viewWithButtonDelegate>
- (IBAction)swipe:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *progressLable;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;
@property (retain, nonatomic) IBOutlet UITextView *result1;
@property (retain, nonatomic) IBOutlet UITextView *result2;
@property (retain, nonatomic) IBOutlet UILabel *question;


@end


