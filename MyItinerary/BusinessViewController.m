//
//  BusinessViewController.m
//  MyItinerary
//
//  Created by Rj on 4/29/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "BusinessViewController.h"

@interface BusinessViewController ()

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sharedTraveler = [Traveler sharedTraveler];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    
    if([self searchForBusiness: self.business])
    {
        self.addToItineraryButton.hidden = YES;
        self.alreadyAddedLabel.hidden = NO;
    }
    else
    {
        self.addToItineraryButton.hidden = NO;
        self.alreadyAddedLabel.hidden = YES;
    }
    
    self.nameLabel.text = self.business.businessName;
    
    NSURL *profileImg = [NSURL URLWithString: self.business.businessProfileImageURL];
    [self.profileImage setImage: [UIImage imageWithData: [NSData dataWithContentsOfURL:profileImg]]];
    
    NSURL *ratingImg = [NSURL URLWithString: self.business.businessRatingImageURL];
    [self.ratingImage setImage: [UIImage imageWithData: [NSData dataWithContentsOfURL:ratingImg]]];
    
    self.reviewCountLabel.text = [NSString stringWithFormat: @"%@ reviews", self.business.businessReviewCount];
    self.categoryLabel.text = self.business.businessCategory;
    self.addressLabel.text = self.business.businessAddress;
    self.cityStateLabel.text = [NSString stringWithFormat: @"%@, %@ %@", self.business.businessCity, self.business.businessState, self.business.businessCountry];

    self.phoneLabel.text = self.business.businessPhone;
    
    self.mapView.delegate = self;
    
    MapPin *annotation = [[MapPin alloc] init];
    annotation.title = self.business.businessName;
    annotation.subtitle = [NSString stringWithFormat: @"%@, %@", self.business.businessCity, self.business.businessState];
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [self.business.businessLatitude floatValue];
    coordinates.longitude = [self.business.businessLongitude floatValue];
    annotation.coordinate = coordinates;
    
    [self.mapView addAnnotation: annotation];
    
    NSArray *annotationArray = self.mapView.annotations;
    [self.mapView showAnnotations:annotationArray animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)searchForBusiness: (Business*)aBusiness
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Itinerary" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id like %@ and travelerID like %@", self.business.businessID, self.sharedTraveler.key];
    [request setPredicate: predicate];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] == 0)
    {
        NSLog(@"Business Not Added");
        
        return NO;
    }
    else
    {
        NSLog(@"Business Already Added");
        
        return YES;
    }
}

- (IBAction)addToItineraryPressed:(id)sender
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName: @"Itinerary" inManagedObjectContext: context];
    NSManagedObject *newBusiness = [[NSManagedObject alloc] initWithEntity: entityDesc insertIntoManagedObjectContext:context];
    
    [newBusiness setValue:self.sharedTraveler.key forKey:@"travelerID"];
    [newBusiness setValue:self.business.businessID forKey:@"id"];
    [newBusiness setValue:self.business.businessName forKey:@"name"];
    [newBusiness setValue:self.business.businessCategory forKey:@"category"];
    [newBusiness setValue:self.business.businessAddress forKey:@"address"];
    [newBusiness setValue:self.business.businessCity forKey:@"city"];
    [newBusiness setValue:self.business.businessState forKey:@"state"];
    [newBusiness setValue:self.business.businessCountry forKey:@"country"];
    [newBusiness setValue:self.business.businessLatitude forKey:@"latitude"];
    [newBusiness setValue:self.business.businessLongitude forKey:@"longitude"];
    [newBusiness setValue:self.business.businessPhone forKey:@"phone"];
    [newBusiness setValue:[NSString stringWithFormat:@"%@", self.business.businessReviewCount] forKey:@"reviewCount"];
    [newBusiness setValue:[NSString stringWithFormat:@"%@", self.business.businessRating] forKey:@"rating"];
    [newBusiness setValue:self.business.businessProfileImageURL forKey:@"profileImageURL"];
    [newBusiness setValue:self.business.businessRatingImageURL forKey:@"ratingImageURL"];
    
    UIImage *profileImage = [self.profileImage image];
    NSData *profileImageData = UIImageJPEGRepresentation(profileImage, 0.0);
    [newBusiness setValue:profileImageData forKey:@"profileImageData"];
    
    UIImage *ratingImage = [self.ratingImage image];
    NSData *ratingImageData = UIImageJPEGRepresentation(ratingImage, 0.0);
    [newBusiness setValue:ratingImageData forKey:@"ratingImageData"];
    
    NSError *error;
    [context save: &error];
    
    self.addToItineraryButton.hidden = YES;
    self.alreadyAddedLabel.hidden = NO;
    
    NSLog(@"Business Added To Itinerary");
}

@end
