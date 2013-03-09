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

@interface SCViewController() <UINavigationControllerDelegate>

@property (retain, nonatomic) NSArray *allFriends;
@property (readwrite, nonatomic) int friendCount;
@property (strong, nonatomic) NSString * name1;
@property (strong, nonatomic) NSString * name2;
@property (retain, nonatomic) UIImage* img1;
@property (retain, nonatomic) UIImage* img2;
@property (strong, nonatomic) NSMutableArray *selectedFriends;

@end

@implementation SCViewController

@synthesize selectedFriends = _selectedFriends;
@synthesize allFriends = _allFriends;
@synthesize friendCount = _friendCount;
@synthesize name1 =_name1;
@synthesize name2 =_name2;
@synthesize img1=_img1;
@synthesize img2=_img2;


- (void) dealloc
{
    _allFriends = nil;
    _selectedFriends = nil;
    _img1 = nil;
    _img2 = nil;
    
    [super dealloc];
}

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Restart"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(restartButtonWasPressed:)];
    /*
    CGRect viewRect = CGRectMake(0,0,480,290);
    UIView* myview = [[UIView alloc] initWithFrame:viewRect];
    [self.view addSubview:myview];
    
    [self.fButton1 setTitle:@"aaa" forState:UIControlStateNormal];
    //[myview addSubview:self.fButton1];
    */
 
    
    if (FBSession.activeSession.isOpen) {
        NSLog(@"start to request");
        [self getPicRequests];
        NSLog(@"%d, %d",rand(),self.friendCount);
        //[self showFriends];

        
    }else {
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          // if login fails for any reason, we alert
                                          if (error) {
                                              [self printError:nil error:error];
                                          } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                              // send our requests if we successfully logged in
                                              [self getPicRequests];
                                          }
                                      }];
    }
    
    //

    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    if (FBSession.activeSession.isOpen) {
        
    } 
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    _allFriends = nil;
    _selectedFriends = nil;
    _img1 = nil;
    _img2 = nil;
     
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}


//restart button
-(void)restartButtonWasPressed:(id)sender {
    
    
}

#pragma mark -  get pictures and name of user's all friends

- (void)getPicRequests {
    [FBRequestConnection startWithGraphPath:@"/me/friends?fields=name,picture.height(200).width(200)"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if(error) {
                                  [self printError:@"Error requesting /me/friends?fields=name,picture.height(200).width(200)" error:error];
                                  return;
                              }
                              self.allFriends = (NSArray*)[result data];
                              self.friendCount = [self.allFriends count];
                              NSLog(@"You have %d friends", self.friendCount);
                              for(int i = 0; i < self.friendCount; i++)
                              {
                                  NSDictionary* friend = [self.allFriends objectAtIndex:i];
                                  NSLog(@"friend name: %@", [friend objectForKey:@"name"]);
                                  NSDictionary* picture = [friend objectForKey:@"picture"];
                                  NSDictionary* data = [picture objectForKey:@"data"];
                                  NSLog(@"photo url: %@", [data objectForKey:@"url"]);
                                  
                              }
                              [self showFriends];
                              
                        }];
    
}

- (void)showFriends{
    //select two friends from friends list randomly
    
    int randNum1 = 0, randNum2 = 0;
    while(randNum1 == randNum2){
        NSLog(@"%d, %d",rand(),self.friendCount);
        randNum1 = rand() % (self.friendCount-1);
        randNum2 = rand() % (self.friendCount-1);
    }
    NSLog(@"%d",randNum1);
    NSLog(@"%d",randNum2);
    
    //get friend name
    NSDictionary* friend1 = [self.allFriends objectAtIndex:randNum1];
    self.name1 = [friend1 objectForKey:@"name"];
    NSDictionary* friend2 = [self.allFriends objectAtIndex:randNum2];
    self.name2 = [friend2 objectForKey:@"name"];
    //get friend1 picture url
    NSDictionary* picture1 = [friend1 objectForKey:@"picture"];
    NSDictionary* data1 = [picture1 objectForKey:@"data"];
    NSString *path1 = [data1 objectForKey:@"url"];
    NSURL *url1 = [NSURL URLWithString:path1];
    NSData *data = [NSData dataWithContentsOfURL:url1];
    self.img1 = [[UIImage alloc] initWithData:data];//dealloc
    CGSize size1 = self.img1.size;
    //get friend2 picture url
    NSDictionary* picture2 = [friend2 objectForKey:@"picture"];
    NSDictionary* data2 = [picture2 objectForKey:@"data"];
    NSString *path2 = [data2 objectForKey:@"url"];
    NSURL *url2 = [NSURL URLWithString:path2];
    data = [NSData dataWithContentsOfURL:url2];
    self.img2 = [[UIImage alloc] initWithData:data];//dealloc
    CGSize size2 = self.img2.size;
    //add pictures to two buttons
    SCsubview *fsubview = [[SCsubview alloc]init];
    [self.view addSubview:fsubview];
    fsubview.frame = CGRectMake(0,0,480,290);
    [fsubview.fButton1 setImage:self.img1 forState:UIControlStateNormal];
    [fsubview.fButton2 setImage:self.img2 forState:UIControlStateNormal];
    //button animation: right to the center of screen
     
    
}

// Shared error handler
-(void)printError:(NSString*)message error:(NSError*)error {
    if(message) {
        NSLog(@"%@", message);
    }
    
    // works for 1 FBRequest per FBRequestConnection
    int userInfoCode = [error.userInfo[@"com.facebook.FBiOSSDK:ParsedJSONResponseKey"][0][@"body"][@"error"][@"code"] integerValue];
    NSString* userInfoMessage = error.userInfo[@"com.facebook.FBiOSSDK:ParsedJSONResponseKey"][0][@"body"][@"error"][@"message"];
    
    // outer error
    NSLog(@"Error: %@", error);
    NSLog(@"Error code: %d", error.code);
    NSLog(@"Error message: %@", error.localizedDescription);
    
    // inner error
    NSLog(@"Error code: %d", userInfoCode);
    NSLog(@"Error message: %@", userInfoMessage);
    if(userInfoCode == 2500) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"Facebook"
                                                      message:@"You're not logged in."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [view show];
        });
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
