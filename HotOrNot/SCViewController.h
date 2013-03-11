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
- (IBAction)swipe:(id)sender;//detect swipe action
@property (retain, nonatomic) IBOutlet UILabel *progressLable;//label to display progress
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;//progress bar
@property (retain, nonatomic) IBOutlet UITextView *result1;//left text view
@property (retain, nonatomic) IBOutlet UITextView *result2;//right text view
@property (retain, nonatomic) IBOutlet UILabel *question;//question label


@end


