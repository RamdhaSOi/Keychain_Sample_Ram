//
//  ViewController.h
//  Keychain_Sample_Ram
//
//  Created by Ramdhas on May,16.
//  Copyright (c) 2014 Ram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic) BOOL pinValidated;

- (IBAction)Submit:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *UserName;
@property (strong, nonatomic) IBOutlet UITextField *Password;

@end
