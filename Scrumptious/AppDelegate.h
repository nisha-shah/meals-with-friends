//
//  AppDelegate.h
//  VolunteerApp
//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

extern NSString *const SCSessionStateChangedNotification;


#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ScrumptiousMainViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong)  NSString* fbId;
@property(strong,nonatomic)NSString *selectedMeal;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UINavigationController *navigationController;
@property(strong,nonatomic)UIViewController *mainViewController;
@property(strong,nonatomic)MainViewController *volunteerVC;
@property(strong,nonatomic)ScrumptiousMainViewController *scrumptiousMainVC;
- (NSDictionary*)parseURLParams:(NSString *)query;

@end
