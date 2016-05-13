//
//  Traveler.h
//  MyItinerary
//
//  Created by Rj on 5/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Traveler : NSObject

@property (strong) NSString *key;
@property (strong) NSString *name;

+ (id)sharedTraveler;

@end
