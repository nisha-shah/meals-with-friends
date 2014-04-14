//
//  UserSignInViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/11/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "UserSignInViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface UserSignInViewController()

@property(strong,nonatomic)PreferencesTableViewController * interestTableVC;
@property(strong,nonatomic)MealListTableViewController * browseTableVC;
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnForSignUp;
@property (strong, nonatomic) IBOutlet UILabel *lblNewUser;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UILabel *lblmainLable;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIImageView *keyImageView;
- (IBAction)btnForSignUpClicked:(id)sender;
- (IBAction)btnRegisterClicked:(id)sender;
- (IBAction)btnSignInClicked:(id)sender;

@end


@implementation UserSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.keyImageView setImage:[UIImage imageNamed:@"login-key.jpg"]];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"Login";
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.lblmainLable.text=@"User Sign In ";
    self.btnRegister.hidden=YES;
    self.txtEmail.hidden=YES;
    self.lblEmail.hidden=YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//the return keyboard shoud disappear
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    return YES;
}

-(void)perfomSignIn:(id)sender{
    self.lblmainLable.text=@"New User Registration";
    self.lblEmail.hidden=NO;
    self.txtEmail.hidden=NO;
    self.btnSignIn.hidden=YES;
    self.btnRegister.hidden=NO;
    
}



- (IBAction)btnRegisterClicked:(id)sender {
    NSLog(@"Button register clicked");
    //validation
    if ([self.txtUserName.text length] == 0|| [self.txtPassword.text length] == 0 || [self.txtEmail.text length]== 0) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                         message:@"Please enter all text fields"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        
        
        [alert1 show];
        return;
    }
    PFUser *user = [PFUser user];
    user.username = self.txtUserName.text;
    user.password = self.txtPassword.text;
    user.email=self.txtEmail.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error) {
             // Display an alert view to show the error message
             UIAlertView *alertView =
             [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"]
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Ok", nil];
             [alertView show];
             return;
         }else{
             //-    NSLog(@"User registered successfully ");
                       self.interestTableVC=[[PreferencesTableViewController alloc]initWithNibName:@"PreferencesTableViewController" bundle:nil];
             [self.navigationController pushViewController:self.interestTableVC animated:YES];
         }
         
     }];


}

- (IBAction)btnSignInClicked:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.txtUserName.text password:self.txtPassword.text block:^(PFUser *user, NSError *error) {
            if (user != nil) {
             self.browseTableVC=[[MealListTableViewController alloc]initWithNibName:@"MealListTableViewController" bundle:nil];
                [self.navigationController pushViewController:self.browseTableVC animated:YES];
            }else{
             //   NSLog(@"Incorrect login");
                UIAlertView *message1 = [[UIAlertView alloc] initWithTitle:@"Login failure !"
                                                                   message:@"Please enter correct credentials"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                [message1 show];
            }
        }];
}


- (IBAction)btnForSignUpClicked:(id)sender {
    self.btnForSignUp.hidden=YES;
    self.lblNewUser.hidden=YES;
    [self perfomSignIn:self];
}
@end
