//
//  LoginViewController.h
//  MyItinerary
//
//  Created by Rj on 5/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>
#import "Traveler.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong) Traveler *sharedTraveler;
@property (strong) Firebase *ref;
@property BOOL isValid;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

- (IBAction)loginPressed:(id)sender;

@end
