//
//  Business.m
//  yelpRank
//
//  Created by Rj on 4/11/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "Business.h"

@implementation Business

@synthesize businessID;
@synthesize businessName;
@synthesize businessCategory;
@synthesize businessProfileImageURL;
@synthesize businessProfileImageData;
@synthesize businessPhone;
@synthesize businessAddress;
@synthesize businessLatitude;
@synthesize businessLongitude;
@synthesize businessCity;
@synthesize businessState;
@synthesize businessCountry;
@synthesize businessRating;
@synthesize businessRatingImageURL;
@synthesize businessRatingImageData;
@synthesize businessReviewCount;

- (Business*) init
{
    self = [super init];
    
    if(self)
    {
        businessID = [[NSString alloc] init];
        businessName = [[NSString alloc] init];
        businessCategory = [[NSString alloc] init];
        businessProfileImageURL = [[NSString alloc] init];
        businessProfileImageData = [[NSData alloc] init];
        businessPhone = [[NSString alloc] init];
        businessAddress = [[NSString alloc] init];
        businessLatitude = [[NSNumber alloc] init];
        businessLongitude = [[NSNumber alloc] init];
        businessCity = [[NSString alloc] init];
        businessState = [[NSString alloc] init];
        businessCountry = [[NSString alloc] init];
        businessRating = [[NSString alloc] init];
        businessRatingImageURL = [[NSString alloc] init];
        businessRatingImageData = [[NSData alloc] init];
        businessReviewCount = [[NSString alloc] init];
    }
    
    return self;
}

- (void) displayBusinessInfo
{
}

@end
