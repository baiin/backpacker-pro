//
//  DirectionsTableViewController.m
//  MyItinerary
//
//  Created by Rj on 4/30/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "DirectionsTableViewController.h"

@interface DirectionsTableViewController ()

@end

@implementation DirectionsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.directions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleIdentifier = @"instructionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    
    NSMutableDictionary *dict = [self.directions objectAtIndex: indexPath.row];
    NSString *type = [dict objectForKey: @"type"];
    NSString *contents = [dict objectForKey: @"contents"];
    
    if([type isEqualToString: @"header"])
    {
        cell.backgroundColor = [UIColor purpleColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = contents;
    
    
    return cell;
}

@end
