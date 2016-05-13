//
//  SearchBusinessViewController.m
//  MyItinerary
//
//  Created by Rj on 4/29/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "SearchBusinessViewController.h"

static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"5";

@interface SearchBusinessViewController ()

@end

@implementation SearchBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.termTextField.delegate = self;
    self.locationTextField.delegate = self;
    
    self.businessList = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)searchPresed:(id)sender
{
    [self queryBusiness:self.termTextField.text location:self.locationTextField.text completionHandler:^(NSMutableArray *businesses, NSError *error)
     {
         if (error)
         {
             NSLog(@"An error happened during the request: %@", error);
         }
         else if (businesses)
         {
             self.businessList = [NSMutableArray arrayWithArray: businesses];
         }
         else
         {
             NSLog(@"No business was found");
         }
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self.tableView reloadData];
                        });
     }];
}

- (NSURLRequest *) searchRequestWithTerm:(NSString *)term location:(NSString *)location {
    NSDictionary *params = @{
                             @"term": term,
                             @"location": location,
                             @"limit": kSearchLimit
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

- (void)queryBusiness:(NSString *)term location:(NSString *)location completionHandler:(void (^)(NSMutableArray *businesses, NSError *error))completionHandler
{
    //Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self searchRequestWithTerm:term location:location];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableArray *businessList = [[NSMutableArray alloc] init];
    
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error && httpResponse.statusCode == 200)
        {
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            //NSLog(@"%@", businessArray);
            
            if ([businessArray count] > 0)
            {
                for(NSDictionary *n in businessArray)
                {
                    Business *newBusiness = [[Business alloc] init];
                    
                    newBusiness.businessID = n[@"id"];
                    newBusiness.businessName = n[@"name"];
                    newBusiness.businessPhone = n[@"display_phone"];
                    newBusiness.businessCategory = [[n[@"categories"] objectAtIndex: 0] objectAtIndex: 0];
                    newBusiness.businessProfileImageURL = n[@"image_url"];
                    
                    NSDictionary *location = n[@"location"];
                    newBusiness.businessAddress = [location[@"address"] objectAtIndex: 0];
                    
                    NSDictionary *coordinate = location[@"coordinate"];
                    newBusiness.businessLatitude = coordinate[@"latitude"];
                    newBusiness.businessLongitude = coordinate[@"longitude"];
                    
                    newBusiness.businessCity = location[@"city"];
                    newBusiness.businessState = location[@"state_code"];
                    newBusiness.businessCountry = location[@"country_code"];
                    
                    newBusiness.businessRating = n[@"rating"];
                    newBusiness.businessRatingImageURL = n[@"rating_img_url"];
                    newBusiness.businessReviewCount = n[@"review_count"];
                    
                    [businessList addObject: newBusiness];
                }
                
                completionHandler(businessList, error);
            }
            else
            {
                completionHandler(nil, error); // No business was found
            }
        }
        else
        {
            completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
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
    
    NSURL *profileImg = [NSURL URLWithString: thisBusiness.businessProfileImageURL];
    [cell.profileImage setImage: [UIImage imageWithData: [NSData dataWithContentsOfURL:profileImg]]];
    
    cell.nameLabel.text = [NSString stringWithFormat: @"%@", thisBusiness.businessName];
    cell.reviewCountLabel.text = [NSString stringWithFormat: @"%@ reviews", thisBusiness.businessReviewCount];
    
    NSURL *ratingImg = [NSURL URLWithString: thisBusiness.businessRatingImageURL];
    [cell.reviewImage setImage: [UIImage imageWithData: [NSData dataWithContentsOfURL:ratingImg]]];
    
    cell.categoryLabel.text = thisBusiness.businessCategory;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.selectedBusiness = [self.businessList objectAtIndex: indexPath.row];
    
    if([segue.identifier isEqualToString: @"toBusiness"])
    {
        NSLog(@"%@", self.selectedBusiness.businessName);
        BusinessViewController *dest = segue.destinationViewController;
        dest.title = self.selectedBusiness.businessName;
        dest.business = self.selectedBusiness;
    }
}

@end
