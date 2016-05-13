//
//  MyItineraryViewController.m
//  MyItinerary
//
//  Created by Rj on 4/29/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "MyItineraryViewController.h"

@interface MyItineraryViewController ()

@end

@implementation MyItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.businessList = [[NSMutableArray alloc] init];
    self.directions = [[NSMutableArray alloc] init];
    self.sharedTraveler = [Traveler sharedTraveler];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self retrieveBusinesses];
    [self plotBusinessesOnMap];
    [self getRoutes];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getRoutes
{
    [self.mapView removeOverlays: self.mapView.overlays];
    self.directions = [[NSMutableArray alloc] init];
    
    if([self.businessList count] > 1)
    {
        for(int i = 0; i < [self.businessList count] - 1; ++i)
        {
            Business *b1 = [self.businessList objectAtIndex: i];
            Business *b2 = [self.businessList objectAtIndex: i + 1];
            
            [self generateRouteBetweenSource:b1 destination:b2];
        }
    }
}

- (void)generateRouteBetweenSource: (Business*)source destination: (Business*)destination
{
    CLLocationCoordinate2D sourceCoord;
    sourceCoord.latitude = [source.businessLatitude floatValue];
    sourceCoord.longitude = [source.businessLongitude floatValue];
    
    CLLocationCoordinate2D destinationCoord;
    destinationCoord.latitude = [destination.businessLatitude floatValue];
    destinationCoord.longitude = [destination.businessLongitude floatValue];
    
    MKPlacemark *placeMarkSrc = [[MKPlacemark alloc] initWithCoordinate:sourceCoord addressDictionary:nil];
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark: placeMarkSrc];
    MKPlacemark *placeMarkDst = [[MKPlacemark alloc] initWithCoordinate:destinationCoord addressDictionary:nil];
    MKMapItem *mapItemDst = [[MKMapItem alloc] initWithPlacemark: placeMarkDst];
    [mapItemSrc setName: @"name1"];
    [mapItemDst setName: @"name2"];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource: mapItemSrc];
    [request setDestination: mapItemDst];
    [request setTransportType: MKDirectionsTransportTypeAutomobile];
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest: request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
    {
        if(error)
        {
            NSLog(@"Direction Error");
        }
        else
        {
            NSString *contents = [NSString stringWithFormat: @"From %@ to %@:", source.businessName, destination.businessName];
            NSMutableDictionary *header = [NSMutableDictionary dictionaryWithDictionary: @{@"type": @"header", @"contents": contents}];
            [self.directions addObject: header];
            [self showRoute: response];
        }
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.alpha = 0.7;
    renderer.lineWidth = 4.0;
    
    return renderer;
}

- (void)showRoute: (MKDirectionsResponse*) response
{
    for(MKRoute *route in response.routes)
    {
        [self.mapView addOverlay: route.polyline level:MKOverlayLevelAboveRoads];
        
        for(MKRouteStep *step in route.steps)
        {
            NSMutableDictionary *instruction = [NSMutableDictionary dictionaryWithDictionary: @{@"type": @"instruction", @"contents": step.instructions}];
            [self.directions addObject: instruction];
        }
    }
}

- (IBAction)directionsPressed:(id)sender
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businessList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleIdentifier = @"businessCell";
    
    SearchBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleIdentifier];
    
    if(cell == nil)
    {
        cell = [[SearchBusinessTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    
    Business *thisBusiness = [self.businessList objectAtIndex: indexPath.row];

    [cell.profileImage setImage: [UIImage imageWithData: thisBusiness.businessProfileImageData]];
    
    cell.nameLabel.text = [NSString stringWithFormat: @"%@", thisBusiness.businessName];
    cell.reviewCountLabel.text = [NSString stringWithFormat: @"%@ reviews", thisBusiness.businessReviewCount];
    
    [cell.reviewImage setImage: [UIImage imageWithData: thisBusiness.businessRatingImageData]];
    
    cell.categoryLabel.text = thisBusiness.businessCategory;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Business *thisBusiness = [self.businessList objectAtIndex: indexPath.row];
        [self deleteBusiness:thisBusiness];
        [self.businessList removeObjectAtIndex:indexPath.row];
        [self retrieveBusinesses];
        [self.mapView removeAnnotations: self.mapView.annotations];
        [self plotBusinessesOnMap];
        [self getRoutes];
        [tableView reloadData]; // tell table to refresh now
    }
}

- (void)deleteBusiness: (Business*) aBusiness
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Itinerary" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id like %@", aBusiness.businessID];
    [request setPredicate: predicate];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] == 0)
    {
        NSLog(@"No Matches Found");
    }
    else
    {
        for(NSManagedObject *n in matches)
        {
            [context deleteObject: n];
        }
        
        [context save: &error];
        
        NSLog(@"Record Deleted");
    }

}

- (void)retrieveBusinesses
{
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Itinerary" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"travelerID like %@", self.sharedTraveler.key];
    [request setPredicate: predicate];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] == 0)
    {
        NSLog(@"Business Not Added");
    }
    else
    {
        self.businessList = [[NSMutableArray alloc] init];
        
        for(NSManagedObject *n in matches)
        {
            Business *newBusiness = [[Business alloc] init];
            
            newBusiness.businessID = [n valueForKey: @"id"];
            newBusiness.businessName = [n valueForKey: @"name"];
            newBusiness.businessCategory = [n valueForKey: @"category"];
            newBusiness.businessAddress = [n valueForKey: @"address"];
            newBusiness.businessCity = [n valueForKey: @"city"];
            newBusiness.businessState = [n valueForKey: @"state"];
            newBusiness.businessCountry = [n valueForKey: @"country"];
            newBusiness.businessLatitude = [n valueForKey: @"latitude"];
            newBusiness.businessLongitude = [n valueForKey: @"longitude"];
            newBusiness.businessPhone = [n valueForKey: @"phone"];
            newBusiness.businessReviewCount = [n valueForKey: @"reviewCount"];
            newBusiness.businessRating = [n valueForKey: @"rating"];
            newBusiness.businessProfileImageURL = [n valueForKey: @"profileImageURL"];
            newBusiness.businessProfileImageData = [n valueForKey: @"profileImageData"];
            newBusiness.businessRatingImageURL = [n valueForKey: @"ratingImageURL"];
            newBusiness.businessRatingImageData = [n valueForKey: @"ratingImageData"];
            
            [self.businessList addObject: newBusiness];
        }
    }
}

- (void)plotBusinessesOnMap
{
    for(Business *business in self.businessList)
    {
        MapPin *annotation = [[MapPin alloc] init];
        annotation.title = business.businessName;
        annotation.subtitle = [NSString stringWithFormat:@"%@, %@ %@", business.businessCity, business.businessState, business.businessCountry];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [business.businessLatitude floatValue];
        coordinate.longitude = [business.businessLongitude floatValue];
        
        annotation.coordinate = coordinate;
        
        [self.mapView addAnnotation: annotation];
    }
    
    NSArray *annotationList = self.mapView.annotations;
    [self.mapView showAnnotations:annotationList animated:YES];
}

- (IBAction)mapStyleSegmentControlPressed:(id)sender
{
    if(self.mapStyleSegmentControl.selectedSegmentIndex == 0)
    {
        self.mapView.mapType = MKMapTypeStandard;
    }
    else
    {
        self.mapView.mapType = MKMapTypeSatellite;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"toBusiness"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedBusiness = [self.businessList objectAtIndex: indexPath.row];

        BusinessViewController *dest = segue.destinationViewController;
        dest.title = self.selectedBusiness.businessName;
        dest.business = self.selectedBusiness;
    }
    else if([segue.identifier isEqualToString: @"toDirections"])
    {
        DirectionsTableViewController *dest = segue.destinationViewController;
        dest.title = @"Directions";
        dest.directions = self.directions;
    }
}

@end
