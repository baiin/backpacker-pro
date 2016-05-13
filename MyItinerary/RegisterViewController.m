//
//  RegisterViewController.m
//  MyItinerary
//
//  Created by Rj on 5/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[Firebase alloc] initWithUrl: @"https://radiant-inferno-6576.firebaseio.com/users"];
    
    self.emailTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.retypePasswordTextField.delegate = self;
    
    self.passwordTextField.secureTextEntry = YES;
    self.retypePasswordTextField.secureTextEntry = YES;
    
    self.warningLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)registerPressed:(id)sender
{
    NSString *email = self.emailTextField.text;
    NSString *name = self.nameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *retypePassword = self.retypePasswordTextField.text;
    
    if([email isEqualToString: @""] || [name isEqualToString: @""] || [password isEqualToString: @""] || [retypePassword isEqualToString: @""])
    {
        NSLog(@"Empty Fields Detected");
        self.warningLabel.text = @"Empty Fields Detected";
    }
    else
    {
        if([password isEqualToString: retypePassword])
        {
            [[[self.ref queryOrderedByChild:@"email"] queryEqualToValue:email] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
             {
                 if(snapshot.value == [NSNull null])
                 {
                     NSLog(@"Email Is Available");
                     // proceed with add
                     NSDictionary *user = @{@"email": email, @"name": name, @"password": password};
                     
                     Firebase *userRef = [self.ref childByAutoId];
                     [userRef setValue: user];
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     NSLog(@"Email Already Exists");
                     self.warningLabel.text = @"Email Already Exists";
                 }
             }];
        }
        else
        {
            NSLog(@"Password Mismatch");
            self.warningLabel.text = @"Password Mismatch";
        }
    }
}


@end
