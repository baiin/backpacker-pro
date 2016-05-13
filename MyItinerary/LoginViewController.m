//
//  LoginViewController.m
//  MyItinerary
//
//  Created by Rj on 5/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sharedTraveler = [Traveler sharedTraveler];
    
    self.ref = [[Firebase alloc] initWithUrl: @"https://radiant-inferno-6576.firebaseio.com/users"];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.passwordTextField.secureTextEntry = YES;
    
    self.warningLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.isValid = NO;
    self.sharedTraveler.key = @"";
    self.sharedTraveler.name = @"";
    self.emailTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginPressed:(id)sender
{
    [[[self.ref queryOrderedByChild:@"email"] queryEqualToValue:self.emailTextField.text] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
     {
         if(snapshot.value == [NSNull null])
         {
             NSLog(@"Invalid Email");
             self.warningLabel.text = @"Invalid Email";
             self.isValid = NO;
         }
         else
         {
             [[[self.ref queryOrderedByChild:@"email"] queryEqualToValue:self.emailTextField.text] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot)
              {
                  NSLog(@"Found: %@", snapshot.value[@"name"]);
                  
                  NSString *pass = snapshot.value[@"password"];
                  
                  if([pass isEqualToString: self.passwordTextField.text])
                  {
                      NSLog(@"Login Success");
                      self.isValid = YES;
                      self.sharedTraveler.key = snapshot.key;
                      self.sharedTraveler.name = snapshot.value[@"name"];
                      [self performSegueWithIdentifier:@"toItinerary" sender:sender];
                  }
                  else
                  {
                      NSLog(@"Invalid Password");
                      self.warningLabel.text = @"Invalid Password";
                      self.isValid = NO;
                  }
              }];
         }
     }];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString: @"toItinerary"])
    {
        if(self.isValid)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }

    return YES;
}

@end
