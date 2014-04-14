//
//  DetailOpportunityViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "DetailMealViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MealProtocol.h"


@interface DetailMealViewController ()
{
@private int _retryCount;
}

@property(strong, nonatomic)IBOutlet UITextView *opportunityTextView;
@property(strong, nonatomic)IBOutlet UIButton *btnShareOnFacebook;
@property(strong, nonatomic)IBOutlet UIImageView *detailOpportunityImage;
@property(strong, nonatomic)UIImage *maskedImage;
@property(strong,nonatomic)PFObject *result;
@property(strong, nonatomic)UIButton *backButton;
- (IBAction)btnShareOnFacebookClicked:(id)sender;

@end

@implementation DetailMealViewController

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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery *query = [PFQuery queryWithClassName:@"Meal"];
    [query whereKey:@"meal_name" equalTo:appDelegate.selectedMeal];
    self.result = [query getFirstObject];
    PFFile *mealFile = [self.result objectForKey:@"meal_image"];
    NSData *imageData = [mealFile getData];
    UIImage *image = [UIImage imageWithData:imageData];
    self.detailOpportunityImage.image=image;
    self.opportunityTextView.text=[self.result objectForKey:@"meal_description"];
    [self makeAppearance];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (IBAction)btnShareOnFacebookClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    id<SCOGMealAction> action= (id<SCOGMealAction>)[FBGraphObject graphObject];
    action[@"meal"]=[self.result objectForKey:@"OG_ObjectId"];
    BOOL presentable = nil != [FBDialogs presentShareDialogWithOpenGraphAction:action
                                        actionType:@"nishaiosapp:eat"
                               previewPropertyName:@"meal"
                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                 if (error) {
                                                     if(error.fberrorCategory == FBErrorCategoryUserCancelled){
                                                         NSLog(@"User pressed cancel button ");
                                                     }
                                                     NSLog(@"In Error Loop");
                                                     NSLog(@"Error: %@", error.description);
                                                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                                                 message:[NSString stringWithFormat:@"Error"]
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK!"
                                                                       otherButtonTitles:nil]
                                                      show];
                                                 }else{
                                                     NSString *completeGesture =[results objectForKey:@"completionGesture"];
                                                     NSString *didComplete = [results objectForKey:@"didComplete"];
                                                     NSLog(@"complete gesture : %@",completeGesture);
                                                     NSLog(@"did complete : %@",didComplete);
                                                     if([completeGesture isEqualToString:@"cancel"]){
                                                         NSLog(@"User canceled publishing story");
                                                     }else if([completeGesture isEqualToString:@"post"]){
                                                         [[[UIAlertView alloc] initWithTitle:@"Result"
                                                                                     message:[NSString stringWithFormat:@"Story shared successfully"]
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"OK !"
                                                                           otherButtonTitles:nil]
                                                          show];
                                                     }
                                                    }
                                             }];
    
    if(!presentable){
    NSLog(@"Share dialog cannot be presented");
        PFFile *imgs = [self.result objectForKey:@"meal_image"];
        NSString *pictureUrl=imgs.url;
        NSString *makeUpUrl=[NSString stringWithFormat:@"http://myscrumptious.parseapp.com/meal?mealid=%@",[self.result objectForKey:@"meal_id"]];
         NSMutableDictionary *params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
         @"Scrumptious", @"name",
         appDelegate.selectedMeal, @"caption",
          self.opportunityTextView.text, @"description",
         makeUpUrl, @"link",
         pictureUrl, @"picture",
         nil];
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 NSLog(@"Error publishing story.");
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     NSLog(@"User canceled story publishing.");
                 } else {
                     NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                     if (![urlParams valueForKey:@"post_id"]) {
                         NSLog(@"User canceled story publishing.");
                     } else {
                         NSString *msg = [NSString stringWithFormat:
                                          @"Story shared successfully"];
                         NSLog(@"%@", msg);
                         [[[UIAlertView alloc] initWithTitle:@"Result"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil]
                          show];
                     }
                 }
             }
         }];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

//UI Changes
-(void)makeAppearance{
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton=NO;
    label.text = [self.result objectForKey:@"meal_name"];
    self.navigationItem.title=label.text;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonClicked:)];
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    self.maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    [self.navigationController.navigationBar setBackgroundImage:self.maskedImage forBarMetrics:UIBarMetricsDefault];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)]){
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [backButton setBackgroundImage:self.maskedImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backButton;
}
//UI Changes

/*
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}*/


- (void)requestPermissionAndPost {
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session, NSError *error) {
                                            if (!error && [FBSession.activeSession.permissions indexOfObject:@"publish_actions"] != NSNotFound) {
                                                // Now have the permission
                                                // [self postOpenGraphAction];
                                            } else if (error){
                                                // Facebook SDK * error handling *
                                                // if the operation is not user cancelled
                                                if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    [self presentAlertForError:error];
                                                }
                                            }
                                        }];
}


- (void)handlePostOpenGraphActionError:(NSError *) error{
    _retryCount++;
    if (error.fberrorCategory == FBErrorCategoryThrottling) {
        if (_retryCount < 2) {
            NSLog(@"Retrying open graph post");
            return;
        } else {
            NSLog(@"Retry count exceeded.");
        }
    }
    if (error.fberrorCategory == FBErrorCategoryPermissions) {
        NSLog(@"Re-requesting permissions");
        [self requestPermissionAndPost];
        return;
    }
    [self presentAlertForError:error];
}

- (void) presentAlertForError:(NSError *)error {
    if (error.fberrorShouldNotifyUser) {
        [[[UIAlertView alloc] initWithTitle:@"Something Went Wrong"
                                    message:error.fberrorUserMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        NSLog(@"Unexpected error:%@", error);
    }
}


@end
