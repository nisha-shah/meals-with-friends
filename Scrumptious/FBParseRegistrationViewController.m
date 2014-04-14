//
//  FBParseRegistrationViewController.m
//  Scrumptious
//
//  Created by Nisha Shah on 7/26/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "FBParseRegistrationViewController.h"
#import <Parse/Parse.h>
#import "MealListTableViewController.h"

@interface FBParseRegistrationViewController ()

@property(strong,nonatomic)MealListTableViewController *mealListVC;
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property(strong, nonatomic)UIImage *maskedImage;
- (IBAction)btnRegisterClicked:(id)sender;

@end

@implementation FBParseRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    self.view.backgroundColor=[UIColor clearColor];
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=YES;
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Set Up Parse Account";
    self.navigationItem.titleView = label;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
    [self setTxtUserName:nil];
    [self setTxtPassword:nil];
    [self setBtnRegister:nil];
    [super viewDidUnload];
}

- (IBAction)btnRegisterClicked:(id)sender{
    PFUser *currentUser = [PFUser currentUser];
    if ([_txtUserName.text length] == 0|| [_txtPassword.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                         message:@"Please enter all text fields"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (currentUser) {
        [currentUser setUsername:_txtUserName.text];
        [currentUser setPassword:_txtPassword.text];
        [currentUser saveInBackground];
        self.mealListVC=[[MealListTableViewController alloc]initWithNibName:@"MealListTableViewController" bundle:nil];
        [self.navigationController pushViewController:self.mealListVC animated:YES];
    }
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}


@end
