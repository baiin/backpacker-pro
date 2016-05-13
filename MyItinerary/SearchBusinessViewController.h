//
//  SearchBusinessViewController.h
//  MyItinerary
//
//  Created by Rj on 4/29/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
#import "NSURLRequest+OAuth.h"
#import "SearchBusinessTableViewCell.h"
#import "BusinessViewController.h"

@interface SearchBusinessViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *termTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong) NSMutableArray *businessList;
@property (strong) Business *selectedBusiness;

- (IBAction)searchPresed:(id)sender;

@end
