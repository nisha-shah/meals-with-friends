//
//  InterestsTableViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/17/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "PreferencesTableViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface PreferencesTableViewController()

@property(strong, nonatomic)NSArray *userInterests;
@property(retain,nonatomic)PFUser *currentUser;
@property(retain,nonatomic)NSString* fbEmailId;
@property(strong,nonatomic)MealListTableViewController *browseOpportunityVC;
-(void)populateInterestsInTable :(NSMutableArray *)interestList;
-(void)showAppearance;

@end

@implementation PreferencesTableViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        //Custom initialisation
    }
    return self;
}

- (void)viewDidLoad{
    self.tableView.allowsMultipleSelection = YES;
    self.parseClassName=@"Interests";
    self.textKey = @"interest_name";
    [super viewDidLoad];
    [self showAppearance];
    self.userInterests=[@[]mutableCopy];
    self.currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"User_Interests"];
    [query whereKey:@"user_email" equalTo:[_currentUser email]];
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(findCallback:error:)];
}

- (void)findCallback:(NSArray *)results error:(NSError *)error{
    if (!error) {
        self.userInterests=results;
        for (PFObject *object in self.userInterests) {
            NSLog(@"%@",[object objectForKey:@"interest_name"]);
        }
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (PFQuery *)queryForTable{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByAscending:@"interest_id"];
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
        cell.textLabel.text = [object objectForKey:@"interest_name"];
        for (PFObject *object in self.userInterests) {
            NSString *a=[object objectForKey:@"interest_name"];
            if ([a isEqualToString:cell.textLabel.text]) {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
        }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}


-(void)collectInterests{
    NSMutableArray *array=[@[] mutableCopy];
    //collect the checkmarked objects
    for(int i=1; i<[self.objects count]+1;i++) {
         NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
         UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [array addObject:cell.textLabel.text];
        }
      }
[self populateInterestsInTable:array];

    
}

-(void)populateInterestsInTable :(NSMutableArray *)interestList{
    //delete the existing records for the current email logged in .
    PFQuery *deleteQuery=[PFQuery queryWithClassName:@"User_Interests"];
    [deleteQuery whereKey:@"user_email" equalTo:self.currentUser.email];
    [deleteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
            for (NSString* ob in interestList) {
                PFObject *insertInterestQuery = [PFObject objectWithClassName:@"User_Interests"];
                insertInterestQuery[@"interest_name"]=ob;
                insertInterestQuery[@"user_email"]=self.currentUser.email;
                [insertInterestQuery saveInBackground];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
}

- (void)objectsWillLoad{
    [super objectsWillLoad];
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

//UI
-(void)showAppearance{
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Settings";
    self.navigationItem.titleView = label;
    self.navigationItem.hidesBackButton=NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonClicked:)];
    // reusing the same image masks for transparency
    [backButton setBackgroundImage:maskedImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backButton;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(collectInterests)];
    [anotherButton setBackgroundImage:maskedImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem=anotherButton;
}

@end
