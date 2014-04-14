//
//  SignUpViewController.m
//  Scrumptious
//
//  Created by Nisha Shah on 8/12/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "SignUpViewController.h"
#import "MealListTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SignUpViewController ()

@property(strong,nonatomic)UIButton *cancelButton;

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.signUpView addSubview:self.cancelButton];
    [self maskButton:self.cancelButton];
    [self maskButton:self.signUpView.signUpButton];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    //check for missing fields
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Please enter all text fields"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    return informationComplete;
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    MealListTableViewController *mealListVC=[[MealListTableViewController alloc]init];
    [self.navigationController pushViewController:mealListVC animated:YES];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up.");
   [[[UIAlertView alloc] initWithTitle:@"Sign In Failed"
                                message:[NSString stringWithFormat:@"%@", error]
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController{
    NSLog(@"User dismissed the signUpViewController");
}

-(void)viewWillAppear:(BOOL)animated{
 [self setDelegate:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//UI changes
-(void)maskButton:(UIButton *)button{
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    [button setBackgroundImage:maskedImage forState:UIControlStateNormal ];
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.cancelButton setFrame:CGRectMake(35.0f, 300.0f, 125.0f, 40.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(166.0f, 300.0f, 125.0f, 40.0f)];
     self.signUpView.dismissButton.hidden=YES;
}

-(void)cancelButtonClicked:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}



@end
