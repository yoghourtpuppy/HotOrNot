//
//  SCViewController.m
//  HotOrNot
//
//  Created by Qing Chen on 3/6/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import "SCViewController.h"
#import "SCAppDelegate.h"
#import "SCLoginViewController.h"

@interface SCViewController() < UITableViewDataSource,
FBFriendPickerDelegate,
UINavigationControllerDelegate,
FBPlacePickerDelegate,
UIActionSheetDelegate>

@property (retain, nonatomic) NSArray *allFriends;
@property (readwrite, nonatomic) int friendCount;

@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) NSMutableArray *selectedFriends;
@property (strong, nonatomic) FBRequestConnection *requestConnection;

@end

@implementation SCViewController
@synthesize friendName = _friendName;
@synthesize selectedFriends = _selectedFriends;
@synthesize allFriends = _allFriends;
@synthesize requestConnection = _requestConnection;
@synthesize friendCount = _friendCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"HOT OR NOT";
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Restart"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(settingsButtonWasPressed:)];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        NSLog(@"start to request");
        [self getFriendRequests];
        //NSDictionary<FBGraphUser>* friend0 = [self.allFriends objectAtIndex:0];
        //[self getPicRequestsWithid:friend0.id];
    }else {
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          // if login fails for any reason, we alert
                                          if (error) {
                                              UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle:@"Error"
                                                message:error.localizedDescription
                                                delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
                                              [alert show];
                                              // if otherwise we check to see if the session is open, an alternative to
                                              // to the FB_ISSESSIONOPENWITHSTATE helper-macro would be to check the isOpen
                                              // property of the session object; the macros are useful, however, for more
                                              // detailed state checking for FBSession objects
                                          } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                              // send our requests if we successfully logged in
                                              [self getFriendRequests];
                                          }
                                      }];
    }

}

- (void) viewDidAppear:(BOOL)animated {
    if (FBSession.activeSession.isOpen) {
        
    } 
}

#pragma mark -  get a list of friends

// Read the ids to request from textObjectID and generate a FBRequest
// object for each one.  Add these to the FBRequestConnection and
// then connect to Facebook to get results.  Store the FBRequestConnection
// in case we need to cancel it before it returns.
//
// When a request returns results, call requestComplete:result:error.
//
- (void)getFriendRequests {
    //request for user's friends list
    FBRequest *requestFriend = [FBRequest  requestForMyFriends];
    //FBRequest *requestPicture = [FBRequest ];
    // create the connection object
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
        
    // create a handler block to handle the results of the request for fbid's profile
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // not the completion we were looking for...
        if (self.requestConnection &&
            connection != self.requestConnection) {
            return;
        }
        
        // clean this up, for posterity
        self.requestConnection = nil;
        
        NSString *text;
        if (error) {
            // error contains details about why the request failed
            text = error.localizedDescription;
            NSLog(@"friend list request error: %@",text);
        } else {
            self.allFriends = [result objectForKey:@"data"];
            self.friendCount = self.allFriends.count;
            NSLog(@"Found: %i friends", self.allFriends.count);
            for (NSDictionary<FBGraphUser>* friend in self.allFriends) {
                NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
            }
        }

    };
    NSDictionary<FBGraphUser>* friend0 = [self.allFriends objectAtIndex:0];
    NSString * graphPath = [NSString stringWithFormat:@"%@/picture?width=200&height=200", friend0.id];
    FBRequest *requestPic = [FBRequest requestWithGraphPath:graphPath parameters:nil HTTPMethod:@"get"];

    FBRequestHandler handler1 =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // not the completion we were looking for...
        if (self.requestConnection &&
            connection != self.requestConnection) {
            return;
        }
        
        // clean this up, for posterity
        self.requestConnection = nil;
        
        NSString *text;
        if (error) {
            // error contains details about why the request failed
            text = error.localizedDescription;
            NSLog(@"friend list request error: %@",text);
        } else {
            NSString * url= [result objectForKey:@"url"];
            NSLog(@"url: %@",url);
            
        }
        
    };
    
    [newConnection addRequest:requestFriend completionHandler:handler];
    [newConnection addRequest:requestPic completionHandler:handler1];
    // if there's an outstanding connection, just cancel
    [self.requestConnection cancel];
    
    // keep track of our connection, and start it
    self.requestConnection = newConnection;
    [newConnection start];
}

- (void)getPicRequestsWithid: (NSString *)userId{
    //request for user's friends list
    NSString * graphPath = [NSString stringWithFormat:@"%@/picture?width=200&height=200", userId];
    FBRequest *requestPic = [FBRequest requestWithGraphPath:graphPath parameters:nil HTTPMethod:@"get"];
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // not the completion we were looking for...
        if (self.requestConnection &&
            connection != self.requestConnection) {
            return;
        }
        
        // clean this up, for posterity
        self.requestConnection = nil;
        
        NSString *text;
        if (error) {
            // error contains details about why the request failed
            text = error.localizedDescription;
            NSLog(@"friend list request error: %@",text);
        } else {
            NSString * url= [result objectForKey:@"url"];
            NSLog(@"url: %@",url);
            
        }

    };
    [newConnection addRequest:requestPic completionHandler:handler];
    [self.requestConnection cancel];
    self.requestConnection = newConnection;
    [newConnection start];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [self.requestConnection cancel];
    self.selectedFriends = nil;
    self.allFriends = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

#pragma mark - FBUserSettingsDelegate methods

- (void)loginViewControllerDidLogUserOut:(id)sender {
    // Facebook SDK * login flow *
    // There are many ways to implement the Facebook login flow.
    // In this sample, the FBLoginView delegate (SCLoginViewController)
    // will already handle logging out so this method is a no-op.
}

- (void)loginViewController:(id)sender receivedError:(NSError *)error{
    // Facebook SDK * login flow *
    // There are many ways to implement the Facebook login flow.
    // In this sample, the FBUserSettingsViewController is only presented
    // as a log out option after the user has been authenticated, so
    // no real errors should occur. If the FBUserSettingsViewController
    // had been the entry point to the app, then this error handler should
    // be as rigorous as the FBLoginView delegate (SCLoginViewController)
    // in order to handle login errors.
    if (error) {
        NSLog(@"Unexpected error sent to the FBUserSettingsViewController delegate: %@", error);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)settingsButtonWasPressed:(id)sender {

    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
