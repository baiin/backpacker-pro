//
//  MyItineraryViewController.h
//  MyItinerary
//
//  Created by Rj on 4/29/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DirectionsTableViewController.h"
#import "SearchBusinessTableViewCell.h"
#import "BusinessViewController.h"
#import "AppDelegate.h"
#import "Traveler.h"
#import "Business.h"
#import "MapPin.h"

@interface MyItineraryViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSManagedObjectContext *context;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapStyleSegmentControl;

@property (strong) Traveler *sharedTraveler;
@property (strong) NSMutableArray *businessList;
@property (strong) Business *selectedBusiness;
@property (strong) NSMutableArray *directions;

@end
