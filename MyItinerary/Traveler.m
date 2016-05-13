//
//  Traveler.m
//  MyItinerary
//
//  Created by Rj on 5/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "Traveler.h"

@implementation Traveler

+ (id)sharedTraveler
{
    static Traveler *shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{shared = [[self alloc] init];});
    
    return shared;
}

- (Traveler*) init
{
    self = [super init];
    
    if(self)
    {
        self.key = [[NSString alloc] init];
        self.name = [[NSString alloc] init];
    }
    
    return self;
}

@end
