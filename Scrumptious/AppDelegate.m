//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

NSString *const SCSessionStateChangedNotification =
@"com.facebook.Scrumptious:SCSessionStateChangedNotification";

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ScrumptiousMainViewController.h"
#import <Parse/Parse.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    [Parse setApplicationId:@"M9HDjHaW7ygJrNHr0qy5taUmJXLphqlv1xmFwgEF"
                  clientKey:@"c1FNBR2CyvKYHwY79wuAeqaD0caouRvGD4EawSMb"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.scrumptiousMainVC=[[ScrumptiousMainViewController alloc]init];
    [self.scrumptiousMainVC setFields:  PFLogInFieldsFacebook |PFLogInFieldsDefault];
    self.navigationController =[[UINavigationController alloc]initWithRootViewController:self.scrumptiousMainVC];
    self.window.rootViewController = self.navigationController;
    
    [FBLoginView class];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *query = [url fragment];
    NSLog(@"query is %@",query);
    if (!query) {
        query = [url query];
    }
    NSLog(@"new query : %@",query);
    NSDictionary *params = [self parseURLParams:query];
    // Check if target URL exists
    NSString *targetURLString = [params valueForKey:@"target_url"];
    NSLog(@"target url string is %@",targetURLString);
    if (targetURLString) {
        NSURL *targetURL = [NSURL URLWithString:targetURLString];
        NSLog(@"target url is %@",targetURL);
        NSDictionary *targetParams = [self parseURLParams:[targetURL query]];
        NSString *deeplink = [targetParams valueForKey:@"mealid"];
        NSLog(@"deep link is %@",deeplink);
        // Check for the 'deeplink' parameter to check if this is one of
        // our incoming mealId feed link
        if (deeplink) {
            NSLog(@"deep link present %@",deeplink);
        }
    }
    return [PFFacebookUtils handleOpenURL:url];
}



- (void)applicationWillTerminate:(UIApplication *)application {
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application	{
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
}

/*
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                               //   [self.loginViewController loginView:nil handleError:error];
                                  NSLog(@"Error is %@",error);
                              }
                          }];
}
 */

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:0]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    NSLog(@"DIctionary ");
    for(id key in params){
        NSLog(@"%@ : %@", key, [params objectForKey:key]);
}
    return params;
}


@end
