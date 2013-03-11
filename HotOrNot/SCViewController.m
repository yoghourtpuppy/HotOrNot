//
//  SCViewController.m
//  HotOrNot
//
//  View controller of the main game view
//  Created by Qing Chen on 3/6/13.
//  Copyright (c) 2013 Qing Chen. All rights reserved.
//

#import "SCViewController.h"
#import "SCAppDelegate.h"
#import "SCLoginViewController.h"
#import "SCselectedFriend.h"
#define SEARCHRANGE 15

@interface SCViewController() <UINavigationControllerDelegate>

@property (retain, nonatomic) NSArray* allFriends;
@property (nonatomic) NSInteger friendCount;
@property (retain, nonatomic) NSDictionary *friend1;
@property (retain, nonatomic) NSDictionary *friend2;
@property (copy, nonatomic) NSString* id1;
@property (copy, nonatomic) NSString * id2;
@property (copy, nonatomic) NSString* name1;
@property (copy, nonatomic) NSString* name2;
@property (retain, nonatomic) UIImage* img1;
@property (retain, nonatomic) UIImage* img2;
@property (retain, nonatomic) NSMutableArray *selectedFriends;
@property (retain,nonatomic) SCsubview* subview;
@property (nonatomic) NSInteger randNum;
@end

@implementation SCViewController

@synthesize selectedFriends = _selectedFriends;
@synthesize allFriends = _allFriends;
@synthesize friendCount = _friendCount;
@synthesize friend1=_friend1;
@synthesize friend2 = _friend2;
@synthesize id1 = _id1;
@synthesize id2 = _id2;
@synthesize name1 =_name1;
@synthesize name2 =_name2;
@synthesize img1=_img1;
@synthesize img2=_img2;
@synthesize subview=_subview;
@synthesize result1 =_result1;
@synthesize result2 = _result2;
@synthesize question = _question;
@synthesize randNum = _randNum;

- (void) dealloc
{
    _allFriends = nil;
    _selectedFriends = nil;
    _img1 = nil;
    _img2 = nil;
    _friend1 =nil;
    _friend2 = nil;
    [_subview release];
    [_progressLable release];
    [_progressBar release];
    [_result1 release];
    [_result2 release];
    [_question release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_subview release];
    _allFriends = nil;
    _selectedFriends = nil;
    _img1 = nil;
    _img2 = nil;
    _friend1 =nil;
    _friend2 = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;

    }
    return self;
}

//The view showing the result
- (void)endView{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Restart"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(restartButtonWasPressed:)];

    //sort and summarize the result
    NSSortDescriptor *countDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
    NSArray *sortDescriptors = @[countDescriptor];
    NSArray *sortedArray = [_selectedFriends sortedArrayUsingDescriptors:sortDescriptors];
    
    //for test
    for(int i = 0; i<10;i++){
        SCselectedFriend * sf = [sortedArray objectAtIndex:i];
        NSLog(@"%d: %@ pts: %d",i,sf.name,sf.count);
    }
     
    self.progressBar.hidden = YES;
    self.progressLable.hidden = YES;
    
    //remove the subview
    [_subview removeFromSuperview];
    
    _result1.hidden = NO;
    _result2.hidden = NO;
    _result1.text = nil;
    _result2.text = nil;
    //show the result
    for(int i = 0; i<5;i++){
        SCselectedFriend * sf = [sortedArray objectAtIndex:i];
        SCselectedFriend * sf1 = [sortedArray objectAtIndex:(i+5)];
        _result1.text =[ _result1.text stringByAppendingString:[NSString stringWithFormat:@"%d.  %@   pts: %d\n\n",i,sf.name,sf.count]];
        _result2.text = [ _result2.text stringByAppendingString:[NSString stringWithFormat:@"%d.  %@   pts: %d\n\n",i+5,sf1.name,sf1.count]];
    }
    //view animation: right to the center of screen
    _result1.frame = CGRectMake(-480,30,230,213);
    _result2.frame = CGRectMake(480,30,230,213);
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         _result1.frame = CGRectMake(0,30,230,213);
                         _result2.frame = CGRectMake(180,30,230,213);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1]];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"bar.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"HOT OR NOT";
    
    //set random questions
    NSArray* array = [NSArray arrayWithObjects:@"Who's more fun?",@"Who's sexier?",@"Who's more foodie?",@"Who's more honest?", nil];
    int randomIndex = arc4random()%array.count;
    self.question.text = [array objectAtIndex:randomIndex];
    
    //add subview to current view
    _subview = [[SCsubview alloc]init];
    _subview.frame = CGRectMake(480,30,480,230);
    [self.view addSubview:_subview];
    _subview.delegate = self;
    
    //hide result blocks and show hud
    _result1.hidden = YES;
    _result2.hidden = YES;
    
    self.progressBar.hidden = NO;
    self.progressLable.hidden = NO;
    self.progressLable.text = @"0/10";
    self.progressBar.progress = 0.0;
    
    if (FBSession.activeSession.isOpen) {
        //start
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

}

#pragma mark -  get pictures and name of user's all friends and show

- (void)requestAndGo {
    //request
    [FBRequestConnection startWithGraphPath:@"/me/friends?fields=name,picture.height(150).width(150)"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              [self requestCompleted:connection result:result error:error];
                                                            
                        }];
    
}

- (void)requestCompleted:(FBRequestConnection *)connection
                  result:(id)result
                   error:(NSError *)error {
    if(error) {
        [self printError:@"Error requesting /me/friends?fields=name,picture.height(150).width(150)" error:error];
        return;
    }
    _allFriends = (NSArray*)[result data];
    _friendCount = [_allFriends count];
    if(_friendCount<10)//less than 10 friends alert and exit
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Few Friends"
                                                        message:@"You have so few friends on Facebook dude...Go and get some!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
    //NSLog(@"You have %d friends", _friendCount);
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
    //array to store selection results
        _selectedFriends = [[NSMutableArray alloc] init];//dealloc
        _randNum = arc4random() %(_friendCount-1);
        [self showFriends];
    }

}

//retrieve callback and show
- (void)showFriends{
    //select two friends from friends list randomly
    //if there are more than a certain nunber of friends, select friends in a range of 20 to increase the posibility
    
    int randNum1 = 0, randNum2 = 0;
    if(_friendCount >= SEARCHRANGE)
    {
        while(randNum1 == randNum2){
            randNum1 = (_randNum + arc4random() % SEARCHRANGE) % (_friendCount-1);
            randNum2 = (_randNum + arc4random() % SEARCHRANGE) % (_friendCount-1);
        }
    }
    else{
        while(randNum1 == randNum2){
            randNum1 = arc4random() % (_friendCount-1);
            randNum2 = arc4random() % (_friendCount-1);
        }
    }
   
    
    //get friend name
    _friend1 = [_allFriends objectAtIndex:randNum1];
    _name1 = [_friend1 objectForKey:@"name"];
    _id1 = [_friend1 objectForKey:@"id"];
    _friend2 = [_allFriends objectAtIndex:randNum2];
    _name2 = [_friend2 objectForKey:@"name"];
    _id2 = [_friend2 objectForKey:@"id"];

    //get friend1 picture url
    NSDictionary* picture1 = [_friend1 objectForKey:@"picture"];
    NSDictionary* data1 = [picture1 objectForKey:@"data"];
    NSString *path1 = [data1 objectForKey:@"url"];
    NSURL *url1 = [NSURL URLWithString:path1];
    NSData *data = [NSData dataWithContentsOfURL:url1];
    _img1 = [[UIImage alloc] initWithData:data];//dealloc
    
    //get friend2 picture url
    NSDictionary* picture2 = [_friend2 objectForKey:@"picture"];
    NSDictionary* data2 = [picture2 objectForKey:@"data"];
    NSString *path2 = [data2 objectForKey:@"url"];
    NSURL *url2 = [NSURL URLWithString:path2];
    data = [NSData dataWithContentsOfURL:url2];
    _img2 = [[UIImage alloc] initWithData:data];//dealloc
    
    [_allFriends retain];
    //add pictures to two buttons
    [_subview.fButton1 setImage:_img1 forState:UIControlStateNormal];
    [_subview.fButton2 setImage:_img2 forState:UIControlStateNormal];
    _subview.name1.text = _name1;
    _subview.name2.text = _name2;
    
    //view animation: right to the center of screen
    _subview.frame = CGRectMake(480,30,480,230);
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                        _subview.frame = CGRectMake(0,30,480,230);
                     }
                     completion:^(BOOL finished){
                         
                     }];
  
}

#pragma mark - user interaction

//restart button
-(void)restartButtonWasPressed:(id)sender {
    
    [self viewDidLoad];
    
}
- (IBAction)swipe:(id)sender {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         _subview.frame = CGRectMake(-480,30,480,230);
                     }
                     completion:^(BOOL finished){
                         [self showFriends];
                     }];

}

-(void)button1Clicked:(UIButton *)button inView:(UIView *)view{
    //NSLog(@"the button1 is clicked in main view");
    [self buttonClickedResponseWithId:_id1 name:_name1];
    
}
-(void)button2Clicked:(UIButton *)button inView:(UIView *)view{
    //NSLog(@"the button2 is clicked in main view");
    [self buttonClickedResponseWithId:_id2 name:_name2];
    
}
-(void)buttonClickedResponseWithId: (NSString*) fid name: (NSString*) fname{
    SCselectedFriend * selectedFriend = [[SCselectedFriend alloc] initWithId:fid name:fname count:1];
    NSEnumerator *enumerator = [_selectedFriends objectEnumerator];
    SCselectedFriend *cursor;
    BOOL friendExist = NO, end = NO;
    
    //calculate result
    if(_selectedFriends.count < 10)
    {
        while(cursor = [enumerator nextObject]){
            if([cursor.fid isEqualToString:selectedFriend.fid]){
                ++cursor.count;
                friendExist = YES;
                break;
            }
        }
        
        if(!friendExist){
            
            [_selectedFriends addObject:selectedFriend];
            //set the progress bar and lable
            NSString* progress = [NSString stringWithFormat:@"%d/10",_selectedFriends.count];
            self.progressLable.text = progress;
            self.progressBar.progress = _selectedFriends.count/10.0;
            
        }
    }else{
        end = YES;
    }
    
    [selectedFriend release];
    selectedFriend = nil;
    
    if(end){
        [self endView];
    }
    else{
        //view animation center to outside of left
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             _subview.frame = CGRectMake(-480,30,480,230);
                         }
                         completion:^(BOOL finished){
                             [self showFriends];
                         }];
        
        
    }

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
