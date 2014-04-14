//
//  BrowseOpportunityTableViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "MealListTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>


@interface MealListTableViewController() 

@property(strong,nonatomic)DetailMealViewController * detailOpportunityVC;
@property(strong,nonatomic)UserSettingViewController * userSettingVC;
@property(nonatomic, readwrite, retain) PFObject *selected_meal;
@property(nonatomic, readwrite, retain)NSMutableArray *intList;;
@property(nonatomic, readwrite, retain)PFQuery *displayOpportunityQuery;
@property(strong, nonatomic)UIImage *maskedImage;
-(void)makeAppearance;

@end


@implementation MealListTableViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        //Custom initialisation
    }
    return self;
}

- (void)viewDidLoad{
    PFUser *currentUserCheck=[PFUser currentUser];
    self.paginationEnabled=YES;
    self.parseClassName=@"Meal";
    self.textKey=@"meal_name";
    [super viewDidLoad];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden=NO;
    [self makeAppearance];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                      style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openSettingsView:)];
    // reusing the same image masks for transparency
    [settingsButton setBackgroundImage:self.maskedImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     self.navigationItem.rightBarButtonItem = settingsButton;
     if (currentUserCheck) {
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(openEditInterestView:)];
    // reusing the same image masks for transparency
    [filterButton setBackgroundImage:self.maskedImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = filterButton;
  }
}

-(void) openEditInterestView:(id)sender{
    PreferencesTableViewController *interestTableVC=[[PreferencesTableViewController alloc]init];
    [self.navigationController pushViewController:interestTableVC animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadObjects];
}

-(void)openSettingsView:(id)sender{
    PFUser *currentUser=[PFUser currentUser];
    if (currentUser) {
        self.userSettingVC=[[UserSettingViewController alloc]init];
        [self.navigationController pushViewController:self.userSettingVC animated:YES];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Account Settings"
                                                           message:@"You must be logged in to view account settings.Do you want to log in ?"
                                                          delegate:self
                                                 cancelButtonTitle:@"NO"
                                                 otherButtonTitles:@"YES", nil];
        message.backgroundColor=[UIColor blackColor];
        [message show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
         NSLog(@"Cancel Button clicked");
    } else {
         ScrumptiousMainViewController *mainVC=[[ScrumptiousMainViewController alloc]init];
        [mainVC setFields:  PFLogInFieldsFacebook |PFLogInFieldsDefault];
        [self.navigationController pushViewController:mainVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
}

- (void)objectsWillLoad{
    [super objectsWillLoad];
}

- (PFQuery *)queryForTable{
    PFUser *currentUser=[PFUser currentUser];
      self.displayOpportunityQuery =[PFQuery queryWithClassName:self.parseClassName];
     if (currentUser) {
        PFQuery *queryInterests = [PFQuery queryWithClassName:@"User_Interests"];
        [queryInterests whereKey:@"user_email" equalTo:currentUser.email];
        NSArray *results= [queryInterests findObjects];
        self.intList=[[NSMutableArray alloc]init];
        for(PFObject *object in results) {
            [self.intList addObject:[object objectForKey:@"interest_name"]];
        }
       if (!([self.intList count]==0)) {
            [self.displayOpportunityQuery whereKey:@"meal_type" containedIn:self.intList];
        }
      } else {
        NSLog(@"CURRENT USER NOT PRESENT");
    }
    [self.displayOpportunityQuery orderByAscending:@"meal_id"];
    return self.displayOpportunityQuery;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    PFFile *theImage = [object objectForKey:@"meal_image"];
    cell.imageView.file = theImage;
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.backgroundColor=[UIColor clearColor];
    
    UILabel* mealImageLabel = [[UILabel alloc]init];
    [mealImageLabel setBackgroundColor:[UIColor clearColor]];
    [mealImageLabel setFrame:CGRectMake(15.0, 15.0, 100.0, 70.0)];
    [mealImageLabel addSubview:cell.imageView];
    [cell addSubview:mealImageLabel];
    
    UILabel * mealNameLabel = [[UILabel alloc]init];
    [mealNameLabel setBackgroundColor:[UIColor clearColor]];
    mealNameLabel.layer.borderColor=(__bridge CGColorRef)([UIColor grayColor]);
    [mealNameLabel setFrame:CGRectMake(135.0, 5.0, 200.0, 25.0)];
    [mealNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [mealNameLabel setTextColor:[UIColor whiteColor]];
    mealNameLabel.text=[object objectForKey:@"meal_name"];
    [cell addSubview:mealNameLabel];
    
    UILabel * mealDescriptionLabel = [[UILabel alloc]init];
    [mealDescriptionLabel setNumberOfLines:0];
    [mealDescriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    mealDescriptionLabel.layer.borderColor=(__bridge CGColorRef)([UIColor grayColor]);
    [mealDescriptionLabel setBackgroundColor:[UIColor clearColor]];
    [mealDescriptionLabel setTextColor:[UIColor whiteColor]];
    [mealDescriptionLabel setFrame:CGRectMake(135.0, 30.0, 150.0, 60.0)];
    mealDescriptionLabel.text=[object objectForKey:@"meal_description"];
    [cell addSubview:mealDescriptionLabel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.detailOpportunityVC=[[DetailMealViewController alloc]initWithNibName:@"DetailMealViewController" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.selected_meal = [self objectAtIndexPath:indexPath];
    appDelegate.selectedMeal=[self.selected_meal objectForKey:@"meal_name"];
    [self.navigationController pushViewController:self.detailOpportunityVC animated:YES];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//UI Changes
-(void)makeAppearance{
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    self.maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    [self.navigationController.navigationBar setBackgroundImage:self.maskedImage forBarMetrics:UIBarMetricsDefault];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)]){
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Meals";
    self.navigationItem.titleView = label;
    self.navigationItem.hidesBackButton=YES;
}


@end
