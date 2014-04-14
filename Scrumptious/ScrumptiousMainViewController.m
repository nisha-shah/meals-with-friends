//
//  ScrumptiousMainViewController.m
//  Scrumptious
//
//  Created by Nisha Shah on 8/12/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "ScrumptiousMainViewController.h"
#import "MealListTableViewController.h"
#import "SignUpViewController.h"
#import "FBParseRegistrationViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface ScrumptiousMainViewController ()

@property(strong,nonatomic)UIButton *skipButton;
@property(strong,nonatomic)MealListTableViewController *mealListVC;
@property(strong,nonatomic)SignUpViewController *signUpViewController;
@property(strong,nonatomic)FBParseRegistrationViewController *fbParseRegistrationVC;
@property(strong,nonatomic)UILabel *appNameLabel;
@property(strong,nonatomic)PFUser *currectUser;

@end

@implementation ScrumptiousMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.currectUser=[PFUser currentUser];
    self.navigationController.navigationBarHidden=YES;
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self addNewFields];
}

- (void)addNewFields{
    self.logInView.dismissButton.hidden=YES;
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.appNameLabel=[[UILabel alloc]init];
    self.appNameLabel.text=@"Scrumptious";
    self.appNameLabel.backgroundColor=[UIColor clearColor] ;
    self.appNameLabel.font = [UIFont italicSystemFontOfSize:20];
    self.appNameLabel.textColor=[UIColor colorWithRed:188 green:149 blue:88 alpha:1.0];
    [self maskButton:self.logInView.logInButton];
    [self maskButton:self.skipButton];
    [self maskButton:self.logInView.signUpButton];
    [self.logInView.signUpButton setTitle:@"No Login? Sign Up" forState:UIControlStateNormal];
    [self.view addSubview:self.skipButton];
 //--   [self.view addSubview:self.appNameLabel];
 }

-(void)maskButton:(UIButton *)button{
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    [button setBackgroundImage:maskedImage forState:UIControlStateNormal ];
    if (!(button == self.logInView.signUpButton)) {
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.appNameLabel setFrame:CGRectMake(120.0f, 15.0f, 150.0f, 78.0f)];
  //--  [self.logInView.logo setFrame:CGRectMake(10.0f, 15.0f, 100.0f, 78.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 100.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
    [self.logInView.facebookButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.skipButton setFrame:CGRectMake(35.0f, 201.0f, 125.0f, 40.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(166.0f, 201.0f, 125.0f, 40.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(75.0f, 265.0f, 180.0f, 40.0f)];
}


- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password{
    if (username.length != 0 && password.length != 0) {
           return YES;
    }
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Please enter all text fields."
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    return NO;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    self.mealListVC=[[MealListTableViewController alloc]init];
    [self.navigationController pushViewController:self.mealListVC animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
    NSLog(@"Failed to login user");
}

-(void)viewDidAppear:(BOOL)animated{
    [self setDelegate:self];
    if (self.currectUser) {
        self.mealListVC=[[MealListTableViewController alloc]init];
        [self.navigationController pushViewController:self.mealListVC animated:NO];
    } else {
        self.logInView.passwordForgottenButton.hidden=YES;
        self.logInView.signUpLabel.hidden=YES;
        self.logInView.externalLogInLabel.hidden=YES;
        [self.logInView.facebookButton removeTarget:nil
                                             action:NULL
                                   forControlEvents:UIControlEventAllEvents];
        [self.logInView.facebookButton addTarget:self
                                          action:@selector(facebookButtonClicked:)
                                forControlEvents:UIControlEventTouchUpInside];
        self.signUpViewController = [[SignUpViewController alloc] init];
        [self.signUpViewController setFields:PFSignUpFieldsDefault];
        [self setSignUpController:self.signUpViewController];
    }
}

- (void)skipButtonClicked:(id)sender{
    self.mealListVC=[[MealListTableViewController alloc]init];
    [self.navigationController pushViewController:self.mealListVC animated:YES];
}

-(void)facebookButtonClicked:(id)sender{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [PFFacebookUtils logInWithPermissions:@[@"basic_info", @"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"The user cancelled Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook");
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store the current user's Facebook ID on the user
                    [[PFUser currentUser] setObject:[result objectForKey:@"email"]forKey:@"email"];
                    [[PFUser currentUser] saveInBackground];
                    appDelegate.fbId=[result objectForKey:@"id"];
                    self.fbParseRegistrationVC=[[FBParseRegistrationViewController alloc] init];
                    [self.navigationController pushViewController:self.fbParseRegistrationVC animated:YES];
                  }
            }];
        } else {
            NSLog(@"User logged in through Facebook!");
            self.mealListVC=[[MealListTableViewController alloc]initWithNibName:@"MealListTableViewController" bundle:nil];
            [self.navigationController pushViewController:self.mealListVC animated:YES];
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store the current user's Facebook ID on the user
                    appDelegate.fbId=[result objectForKey:@"id"];
                    NSLog(@"FB id is %@",appDelegate.fbId);
                }
            }];
        }
    }];
}

@end
