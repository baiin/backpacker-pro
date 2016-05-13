//
//  BusinessViewController.h
//  MyItinerary
//
//  Created by Rj on 4/29/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "MapPin.h"
#import "Business.h"
#import "Traveler.h"

@interface BusinessViewController : UIViewController <MKMapViewDelegate, UINavigationControllerDelegate>
{
    NSManagedObjectContext *context;
}

@property (strong) Business *business;
@property (strong) Traveler *sharedTraveler;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *addToItineraryButton;
@property (weak, nonatomic) IBOutlet UILabel *alreadyAddedLabel;
- (IBAction)addToItineraryPressed:(id)sender;

@end
