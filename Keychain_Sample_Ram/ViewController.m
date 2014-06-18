//
//  ViewController.m
//  Keychain_Sample_Ram
//
//  Created by Ramdhas on May,16.
//  Copyright (c) 2014 Ram. All rights reserved.
//

#import "ViewController.h"
#import "ChristmasConstants.h"
#import "KeychainWrapper.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize pinValidated,UserName,Password;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pinValidated = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)UserNameAction:(id)sender
{
    UserName.tag= kTextFieldName;
    NSLog(@"User entered name");
    if ([UserName.text length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:UserName.text forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)Password:(id)sender
{
    Password.tag = kTextFieldPassword;
    NSLog(@"User entered PIN");

}

- (BOOL)credentialsValidated
{
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    BOOL pin = [[NSUserDefaults standardUserDefaults] boolForKey:PIN_SAVED];
    if (name && pin)
    {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)Submit:(id)sender
{
    BOOL hasPin = [[NSUserDefaults standardUserDefaults] boolForKey:PIN_SAVED];
    if (hasPin)
    {
        if ([Password.text length] > 0)
        {
            NSUInteger fieldHash = [Password.text hash];
            if ([KeychainWrapper compareKeychainValueForMatchingPIN:fieldHash])
            {
                UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Authenticated" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [Alert show];
                [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];

                NSLog(@"** User Authenticated!!");
                self.pinValidated = YES;
                [self performSegueWithIdentifier:@"TestSegue" sender:nil];
            }
            else
            {
                UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:nil message:@"Wrong Password" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [Alert show];
                [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];

                NSLog(@"** Wrong Password :(");
                self.pinValidated = NO;
            }
        }
    }
    else
    {
        if ([Password.text length] > 0)
        {
            NSUInteger fieldHash = [Password.text hash];
            // 4
            NSString *fieldString = [KeychainWrapper securedSHA256DigestHashForPIN:fieldHash];
            NSLog(@"** Password Hash - %@", fieldString);
            // Save PIN hash to the keychain (NEVER store the direct PIN)
            if ([KeychainWrapper createKeychainValue:fieldString forIdentifier:PIN_SAVED])
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:nil message:@"Key saved successfully to Keychain!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [Alert show];
                [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
                [self performSegueWithIdentifier:@"TestSegue" sender:nil];

                NSLog(@"** Key saved successfully to Keychain!!");
            }
        }
    }
}

-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


@end
