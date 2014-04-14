//
//  AboutViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/17/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "AboutViewController.h"
#import "MainViewController.h"
#import "MealListTableViewController.h"

@interface AboutViewController ()

@property(strong,nonatomic)VolunteerViewController *volunteerVC;
@property(strong,nonatomic)MealListTableViewController *browseOpportunityVC;
-(void)showAppearance;

@end

@implementation AboutViewController

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
    [self showAppearance];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)showAppearance{
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"About";
    self.navigationItem.titleView = label;
    self.navigationItem.hidesBackButton=NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonClicked:)];
    // reusing the same image masks for transparency
    [backButton setBackgroundImage:maskedImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backButton;
  
    
}

@end
