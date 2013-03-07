//
//  SCAppDelegate.h
//  HotOrNot
//
//  Created by Qing Chen on 3/6/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class SCViewController;
@class SCLoginViewController;

// Scrumptious sample application
//
// The purpose of the Scrumptious sample application is to demonstrate a complete real-world
// application that includes Facebook integration, friend picker, place picker, and Open Graph
// Action creation and posting.
@interface SCAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) SCViewController *mainViewController;

@property (strong, nonatomic) SCLoginViewController* loginViewController;

@property BOOL isNavigating;

@end
