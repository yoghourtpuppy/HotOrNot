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

@property (strong, nonatomic) FBUserSettingsViewController *settingsViewController;
@property (retain, nonatomic) NSArray *allFriends;
@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) NSArray *selectedFriends;
@property (strong, nonatomic) FBRequestConnection *requestConnection;

@end

@implementation SCViewController
@synthesize friendName = _friendName;
@synthesize selectedFriends = _selectedFriends;

@synthesize settingsViewController = _settingsViewController;
@synthesize allFriends = _allFriends;
@synthesize requestConnection = _requestConnection;

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
                                              initWithTitle:@"Profile"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(settingsButtonWasPressed:)];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        //TODO
    }
}

- (void) viewDidAppear:(BOOL)animated {
    if (FBSession.activeSession.isOpen) {
        // login is integrated with the send button -- so if open, we send
        NSLog(@"start to request");
        [self sendRequests];
        
    } else {
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          // if login fails for any reason, we alert
                                          if (error) {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
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
                                              [self sendRequests];
                                          }
                                      }];
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
- (void)sendRequests {
    //request for user's friends list
    FBRequest *request = [FBRequest  requestForMyFriends];
    
    // create the connection object
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
        
    // create a handler block to handle the results of the request for fbid's profile
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection result:result error:error];
    };
 
    
    [newConnection addRequest:request completionHandler:handler];
    
    
    // if there's an outstanding connection, just cancel
    [self.requestConnection cancel];
    
    // keep track of our connection, and start it
    self.requestConnection = newConnection;
    [newConnection start];
}

// FBSample logic
// Report any results.  Invoked once for each request we make.
- (void)requestCompleted:(FBRequestConnection *)connection
                  result:(id)result
                   error:(NSError *)error {
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
        // Process the results
        NSMutableArray *friendsWithApp = [[NSMutableArray alloc] init];
        // Many results
        if ([result isKindOfClass:[NSArray class]]) {
            [friendsWithApp addObjectsFromArray:result];
        } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
            [friendsWithApp addObject: [result stringValue]];
            int count= 0;
            for(NSString* friend in friendsWithApp)
            {
                count++;
             NSLog(@"friend %d: %@",count,friend);
            }
        }
    }
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [self.requestConnection cancel];
    
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
    if (self.settingsViewController == nil) {
        self.settingsViewController = [[FBUserSettingsViewController alloc] init];
        self.settingsViewController.delegate = self;
    }
    
    [self.navigationController pushViewController:self.settingsViewController animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
