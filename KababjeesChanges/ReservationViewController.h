//
//  ReservationViewController.h
//  KababjeesChanges
//
//  Created by Amerald on 26/08/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface ReservationViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray * BArray;
@property (strong, nonatomic) IBOutlet UIButton *SButton;

@property (strong, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *TabBar;

@property (strong, nonatomic) IBOutlet UITextField *DateTime;
@property (strong, nonatomic) IBOutlet UITableView *dropdownTable;
@property (strong, nonatomic) IBOutlet UITextField *Branch;
@property (strong, nonatomic) IBOutlet UITextField *CName;
@property (strong, nonatomic) IBOutlet UITextField *CEmail;
@property (strong, nonatomic) IBOutlet UITextField *CPhoneNo;
@property (strong, nonatomic) IBOutlet UITextField *CPersons;

- (IBAction)DateTime:(id)sender;
- (IBAction)SelectBranch:(id)sender;
- (IBAction)CloseDatePicker:(id)sender;
- (IBAction)SubmitButton:(id)sender;

@end
