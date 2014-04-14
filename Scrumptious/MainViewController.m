//
//  VolunteerViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "FBParseRegistrationViewController.h"


@interface MainViewController() <FBLoginViewDelegate>

@property(strong,nonatomic)MealListTableViewController * mealListVC;//browseViewController;
@property(strong,nonatomic)FBParseRegistrationViewController * fbParseRegistrationVC;
@property(strong,nonatomic)UserSignInViewController * userSignInVC;

@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnBrowseOpportunities;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property(strong,nonatomic)MealListTableViewController *browseOpportunityVC;


- (IBAction)buttonSignInClicked:(id)sender;
//- (IBAction)buttonLoginWithFacebookClicked:(id)sender;
- (IBAction)buttonBrowseOpportunitiesClicked:(id)sender;


@end


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
        
    self.navigationController.navigationBarHidden=YES;
  
  /*  FBLoginView *loginview = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
    loginview.frame = CGRectOffset(loginview.frame, 70, 300);
    loginview.delegate = self;
    [self.view addSubview:loginview];
    [loginview sizeToFit];*/

    [self styleButtons:self.btnSignIn];
    }


-(void)styleButtons:(UIButton*)btn{

    btn.layer.cornerRadius=15;
    btn.clipsToBounds=YES;
    [[btn layer] setBorderWidth:2.0f];
   [[btn layer] setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;

}

- (IBAction)buttonSignInClicked:(id)sender {
    
   //- NSLog(@"In Sign In Button");
    self.userSignInVC=[[UserSignInViewController alloc]initWithNibName:@"UserSignInViewController" bundle:nil];
    [self.navigationController pushViewController:self.userSignInVC animated:YES];
}

- (IBAction)buttonLoginWithFacebookClicked:(id)sender {
    
    NSLog(@"In FB Login");
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [PFFacebookUtils logInWithPermissions:@[@"basic_info", @"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store the current user's Facebook ID on the user
                    [[PFUser currentUser] setObject:[result objectForKey:@"email"]
                                             forKey:@"email"];
                    [[PFUser currentUser] saveInBackground];
                    appDelegate.fbId=[result objectForKey:@"id"];
                    NSLog(@"FB id is %@",appDelegate.fbId);

                                        self.fbParseRegistrationVC=[[FBParseRegistrationViewController alloc]initWithNibName:@"FBParseRegistrationViewController" bundle:nil];
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

- (IBAction)buttonBrowseOpportunitiesClicked:(id)sender {
  self.mealListVC=[[MealListTableViewController alloc]initWithNibName:@"MealListTableViewController" bundle:nil];
  [self.navigationController pushViewController:self.mealListVC animated:YES];
}


- (void)viewDidUnload {   
    [super viewDidUnload];
}

@end
