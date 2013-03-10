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
#import "SCselectedFriend.h"

@interface SCViewController() <UINavigationControllerDelegate>

@property (retain, nonatomic) NSArray *allFriends;
@property (nonatomic) NSInteger friendCount;
@property (copy, nonatomic) NSString * id1;
@property (copy, nonatomic) NSString * id2;
@property (copy, nonatomic) NSString * name1;
@property (copy, nonatomic) NSString * name2;
@property (retain, nonatomic) UIImage* img1;
@property (retain, nonatomic) UIImage* img2;
@property (retain, nonatomic) NSMutableArray *selectedFriends;
//@property(retain,nonatomic) NSMutableDictionary *selectedFriend;
@property (retain,nonatomic) SCsubview *subview;
@property (nonatomic) BOOL b1clicked;
@property (nonatomic) BOOL b2clicked;
@end

@implementation SCViewController

@synthesize selectedFriends = _selectedFriends;
//@synthesize selectedFriend = _selectedFriend;
@synthesize allFriends = _allFriends;
@synthesize friendCount = _friendCount;
@synthesize id1 = _id1;
@synthesize id2 = _id2;
@synthesize name1 =_name1;
@synthesize name2 =_name2;
@synthesize img1=_img1;
@synthesize img2=_img2;
@synthesize subview=_subview;
@synthesize b1clicked = _b1clicked;
@synthesize b2clicked = _b2clicked;


- (void) dealloc
{
    _allFriends = nil;
    _selectedFriends = nil;
    _img1 = nil;
    _img2 = nil;
    [_subview release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;
        //add subview to current view
        _subview = [[SCsubview alloc]init];
        _subview.frame = CGRectMake(480,30,480,290);
        [self.view addSubview:_subview];
        _subview.delegate = self;
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
   // _selectedFriends =
 
    
    if (FBSession.activeSession.isOpen) {
        NSLog(@"start to request and go!");
        [self requestAndGo];
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
                                              [self requestAndGo];
                                          }
                                      }];
    }
    
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
    [_subview release];
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

- (void)requestAndGo {
    [FBRequestConnection startWithGraphPath:@"/me/friends?fields=name,picture.height(150).width(150)"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if(error) {
                                  [self printError:@"Error requesting /me/friends?fields=name,picture.height(150).width(150)" error:error];
                                  return;
                              }
                              _allFriends = (NSArray*)[result data];
                              _friendCount = [_allFriends count];
                              NSLog(@"You have %d friends", _friendCount);
                              /*for test
                              for(int i = 0; i < _friendCount; i++)
                              {
                                  NSDictionary* friend = [_allFriends objectAtIndex:i];
                                  NSLog(@"friend name: %@", [friend objectForKey:@"name"]);
                                  NSDictionary* picture = [friend objectForKey:@"picture"];
                                  NSDictionary* data = [picture objectForKey:@"data"];
                                  NSLog(@"photo url: %@", [data objectForKey:@"url"]);
                                  
                              }
                               */

                              [self showFriends];
                              int index = 0;
                              if(1||_b1clicked||_b2clicked){
                                if(_b1clicked){
                                    _b1clicked = NO;
                                    SCselectedFriend * selectedFriend = [[SCselectedFriend alloc] initWithId:_id1 name:_name1 count:1];
                                    selectedFriend.count = 2;
                                    NSLog(@"count: %d",selectedFriend.count);
                                }
                                else if(_b2clicked){
                                    _b1clicked = NO;
                                }
                                  //animation
                              }
                              
                        }];
    
}

- (void)showFriends{
    //select two friends from friends list randomly
    int randNum1 = 0, randNum2 = 0;
    while(randNum1 == randNum2){
        randNum1 = arc4random() % (_friendCount-1);
        randNum2 = arc4random() % (_friendCount-1);
    }
    NSLog(@"%d",_friendCount);
    
    //get friend name
    NSDictionary* friend1 = [_allFriends objectAtIndex:randNum1];
    _name1 = [friend1 objectForKey:@"name"];
    _id1 = [friend1 objectForKey:@"id"];
    NSDictionary* friend2 = [_allFriends objectAtIndex:randNum2];
    _name2 = [friend2 objectForKey:@"name"];
    _id2 = [friend2 objectForKey:@"id"];
    
    //get friend1 picture url
    NSDictionary* picture1 = [friend1 objectForKey:@"picture"];
    NSDictionary* data1 = [picture1 objectForKey:@"data"];
    NSString *path1 = [data1 objectForKey:@"url"];
    NSURL *url1 = [NSURL URLWithString:path1];
    NSData *data = [NSData dataWithContentsOfURL:url1];
    _img1 = [[UIImage alloc] initWithData:data];//dealloc
    //CGSize size1 = _img1.size;
    
    //get friend2 picture url
    NSDictionary* picture2 = [friend2 objectForKey:@"picture"];
    NSDictionary* data2 = [picture2 objectForKey:@"data"];
    NSString *path2 = [data2 objectForKey:@"url"];
    NSURL *url2 = [NSURL URLWithString:path2];
    data = [NSData dataWithContentsOfURL:url2];
    _img2 = [[UIImage alloc] initWithData:data];//dealloc
    //CGSize size2 = _img2.size;
    
    //add pictures to two buttons
    [_subview.fButton1 setImage:_img1 forState:UIControlStateNormal];
    [_subview.fButton2 setImage:_img2 forState:UIControlStateNormal];
    
    //view animation: right to the center of screen

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    _subview.frame = CGRectMake(0,30,480,290);
    [UIView commitAnimations];
    
}

-(void)button1Clicked:(UIButton *)button inView:(UIView *)view{
    NSLog(@"the button1 is clicked in main view");
    _b1clicked = YES;
}
-(void)button2Clicked:(UIButton *)button inView:(UIView *)view{
    NSLog(@"the button2 is clicked in main view");
    _b2clicked = YES;
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
