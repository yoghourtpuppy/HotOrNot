//
//  SCLoginViewController.h
//  HotOrNot
//
//  Created by Qing Chen on 3/6/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

/*
 The UIViewController representing the Scrumptious landing page.
 */
@interface SCLoginViewController : UIViewController<FBLoginViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet FBLoginView *FBLoginView;


@end
