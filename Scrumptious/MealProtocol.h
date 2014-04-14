//
//  MealProtocol.h
//  VolunteerApp
//
//  Created by Nisha Shah on 6/27/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol OGMeal<FBGraphObject>

@property (retain, nonatomic) NSString  *id;
@property (retain, nonatomic) NSString  *url;
@property (retain, nonatomic) NSString  *title;

@end


@protocol SCOGMealAction<FBOpenGraphAction>

@property (retain, nonatomic) id<OGMeal>   eat;

@end

