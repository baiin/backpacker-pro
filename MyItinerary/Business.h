//
//  Business.h
//  yelpRank
//
//  Created by Rj on 4/11/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (strong) NSString *businessID;
@property (strong) NSString *businessName;
@property (strong) NSString *businessCategory;
@property (strong) NSString *businessProfileImageURL;
@property (strong) NSData *businessProfileImageData;
@property (strong) NSString *businessPhone;
@property (strong) NSString *businessAddress;
@property (strong) NSNumber *businessLatitude;
@property (strong) NSNumber *businessLongitude;
@property (strong) NSString *businessCity;
@property (strong) NSString *businessState;
@property (strong) NSString *businessCountry;
@property (strong) NSString *businessRating;
@property (strong) NSString *businessRatingImageURL;
@property (strong) NSData *businessRatingImageData;
@property (strong) NSString *businessReviewCount;

- (void) displayBusinessInfo;

@end
