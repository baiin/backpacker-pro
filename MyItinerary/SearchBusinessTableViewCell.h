//
//  SearchBusinessTableViewCell.h
//  MyItinerary
//
//  Created by Rj on 4/29/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBusinessTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *reviewImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end
