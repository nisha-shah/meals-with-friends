//
//  UserSettingViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/19/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "UserSettingViewController.h"
#import "AppDelegate.h"
#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface UserSettingViewController()

@property(retain,nonatomic)PFQueryTableViewController * interestTableVC;
@property(strong,nonatomic)AboutViewController *aboutViewController;
@property(strong,nonatomic)NSMutableData * imageData ;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *facebookUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblParseUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblParseEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
@property (strong, nonatomic) IBOutlet UILabel *lblUserNameField;
@property (strong, nonatomic) IBOutlet UILabel *lblUserEmailField;
@property(strong,nonatomic)UIButton *infoButton;
- (IBAction)btnLogOutClicked:(id)sender;
-(void)showAppearance;

@end

@implementation UserSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        }
    return self;
}

- (void)viewDidLoad{
    self.view.backgroundColor=[UIColor clearColor];
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationItem.title = @"Settings";
    [self showAppearance];
 
    PFUser *currentUser=[PFUser currentUser];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSLog(@"1 . Received fb id is %@",appDelegate.fbId);
    if (appDelegate.fbId!=NULL) {
        NSLog(@"Received fb id is %@",appDelegate.fbId);
        self.lblUserNameField.hidden=YES;
        } else {
        NSLog(@"Did not receive fb id");
        self.facebookUserName.hidden=YES;
        self.userProfilePicture.hidden=YES;
        self.lblUserEmailField.text=currentUser.email;
        self.lblUserNameField.text=currentUser.username;
    }
  }

- (void)populateUserDetails{
    if (FBSession.activeSession.isOpen){
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.facebookUserName.text = user.name;
                 AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                 if (appDelegate.fbId!=NULL) {
                 self.lblUserEmailField.text = [user objectForKey:@"email"];
                 }
                 _userProfilePicture.profileID=user.id;
            }
         }];
    }
}


- (void)btnLogoutClicked:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.fbId=NULL;
    [PFUser logOut];
    ScrumptiousMainViewController *mainVC=[[ScrumptiousMainViewController alloc]init];
    [mainVC setFields:  PFLogInFieldsFacebook |PFLogInFieldsDefault];
    [self.navigationController pushViewController:mainVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self populateUserDetails];
 }

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(void)btnAboutAppClicked:(id)sender{
    self.aboutViewController=[[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:self.aboutViewController animated:YES];

}

-(void)maskButton:(UIButton *)button{
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    [button setBackgroundImage:maskedImage forState:UIControlStateNormal ];
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
}


- (IBAction)btnLogOutClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.fbId=NULL;
    [PFUser logOut];
    ScrumptiousMainViewController *mainVC=[[ScrumptiousMainViewController alloc]init];
    [mainVC setFields:  PFLogInFieldsFacebook |PFLogInFieldsDefault];
    [self.navigationController pushViewController:mainVC animated:YES];
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)showAppearance{
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    
    // for setting title on navigation bar --> Settings
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Settings";
    self.navigationItem.titleView = label;
    
    self.navigationItem.hidesBackButton=NO;
    self.infoButton=[UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.infoButton addTarget:self action:@selector(btnAboutAppClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.infoButton];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonClicked:)];
    // reusing the same image masks for transparency
    [backButton setBackgroundImage:maskedImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backButton;
    [self maskButton:self.btnLogOut];

}



@end
