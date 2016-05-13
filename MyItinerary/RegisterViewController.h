//
//  RegisterViewController.h
//  MyItinerary
//
//  Created by Rj on 5/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (strong)  Firebase *ref;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *retypePasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

- (IBAction)registerPressed:(id)sender;

@end
