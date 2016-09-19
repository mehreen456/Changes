//
//  ReservationViewController.m
//  KababjeesChanges
//
//  Created by Amerald on 26/08/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "ReservationViewController.h"

@interface ReservationViewController ()
{
    NSDateFormatter *dateFormatter,*dateFormatter1;
    CGRect oldFrame;
    NSMutableArray *Json,*Pdata;
    NSString *Bid,*email,*persons,*name,*datetime,*phone,*AvailableTime,*time,*branch;
    NSDictionary *jsonDictionary;
    NSDate *mydate;
    int timestamp,move;
    BOOL ismove;
    long L_datetime,L_Bid;
}
@end

@implementation ReservationViewController
@synthesize DateTime,DatePicker,Branch,BArray,dropdownTable,CName,CPersons,CPhoneNo,CEmail,SButton;
- (void)viewDidLoad {
  
    move=0;ismove=NO;
    [self DateTime].enabled = NO;
    [super viewDidLoad];
    [self set];
    [self retriveData];
    if(showmenu)
       [self show];
    Pdata=[[NSMutableArray alloc]init];
  
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return BArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BCELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Categories *currentCat=[BArray objectAtIndex:indexPath.row];
    
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text=currentCat.CName ;
    [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
   
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Categories *c1= [BArray objectAtIndex:indexPath.row];
    Bid=c1.CId;
    self.Branch.text=c1.CName;
    
    if([Bid isEqualToString:@"MAS"] || [Bid isEqualToString:@"CF"])
        self.DateTime.placeholder=@"Timings 12:00 to 23:59 ";
    else
        self.DateTime.placeholder=@"Timings 18:00 to 23:59 ";


    [self.dropdownTable deselectRowAtIndexPath:[self.dropdownTable indexPathForSelectedRow] animated:NO];
    [self.dropdownTable setContentOffset:CGPointZero animated:NO];
     self.dropdownTable.hidden = YES;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.dropdownTable.hidden = YES;
    if(textField==self.DateTime || textField==self.Branch)
    {  [self.view endEditing:YES];
        return NO;
    }
    else
    {
        if(textField==self.CPhoneNo || textField==self.CPersons)
         {
                CGRect newFrame = [self.view frame];
                newFrame.origin.y =oldFrame.origin.y-150;
                [self.view setFrame:newFrame];
                move=0;
         }
        
        return YES;
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.CName)
        [self.CEmail becomeFirstResponder];
    
    else if (textField == self.CEmail)
    {   if(![self validateEmailWithString:self.CEmail.text])
        {
            [self showMessage:@"Invalid Email" :@"Please enter correct email address."];
            return NO;
        }
        else
        [self.CPhoneNo becomeFirstResponder];
    }
    else if (textField == self.CPhoneNo)
    {
        [self.CPersons becomeFirstResponder];
    }
    
    else
        [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.15 animations:^
     {
         CGRect newFrame = [self.view frame];
         newFrame.origin.y -= 30;
         [self.view setFrame:newFrame];
        
         
     }completion:^(BOOL finished)
     {
         
     }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.15 animations:^
     {
         CGRect newFrame = [self.view frame];
         newFrame.origin.y = oldFrame.origin.y;
         [self.view setFrame:newFrame];
         
     }completion:^(BOOL finished)
     {
         
     }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.dropdownTable.hidden = YES;
    [self Branch].enabled = YES;
    [self.view endEditing:YES];
}


#pragma mark - Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.dropdownTable.alwaysBounceVertical = NO;
}

#pragma mark - Post Data Through API

-(void) PostData
{
    NSString *string = [NSString stringWithFormat:@"%@/reservations", BaseUrl];
    NSURL *URL = [NSURL URLWithString:string];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:DataType forHTTPHeaderField:CType];
    [request setValue:Key forHTTPHeaderField:Authorization];
    L_datetime = [datetime longLongValue];
      L_Bid= [Bid longLongValue];
    jsonDictionary =@{@"time": [NSNumber numberWithLongLong:L_datetime],
                      @"no_of_person":persons,
                      @"phone":phone,
                      @"name":name,
                      @"branch_id":[NSNumber numberWithLongLong:L_Bid],
                      @"email": email,
                      };
    [Pdata addObject:jsonDictionary];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:jsonData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                         // NSLog(@"Error ... ");
                                          return;
                                      }
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                         // NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                         // NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                    //  NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                     // NSLog(@"Response Body:\n%@\n", body);
                                  }];
    [task resume];
}

#pragma mark - Buttons Function

- (IBAction)DateTime:(id)sender {
  
    [self validTime];
    self.DateTime.text=nil;
    dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    dateFormatter1 =[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    self.SButton.enabled=NO;
    self.DatePicker.hidden=NO;
    self.TimePicker.hidden=NO;
    self.TabBar.hidden=NO;
    [self.view endEditing:YES];
}

- (IBAction)CloseDatePicker:(id)sender {
  
    if(self.TimePicker.date==nil)
    {
        [self.view makeToast:@"Error"];
    }
   
   if(![self day])
   {
    self.DateTime.text=[NSString stringWithFormat:@"%@" ,[dateFormatter stringFromDate:self.DatePicker.date]];
    self.DateTime.text=[[self.DateTime.text stringByAppendingString:@" " ] stringByAppendingString: [NSString stringWithFormat:@"%@" ,[dateFormatter1 stringFromDate:self.TimePicker.date]]];
    time=self.DateTime.text;
    NSDateFormatter * dateFormatter2 = [[NSDateFormatter alloc] init] ;
    [dateFormatter2 setDateFormat:@"dd/MM/yyyy  HH:mm"] ;
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter2 setTimeZone:gmt];
    NSDate *date = [dateFormatter2 dateFromString:self.DateTime.text] ;
    NSTimeInterval interval  = [date timeIntervalSince1970] ;
    datetime=[NSString stringWithFormat:@"%f", interval];
    self.SButton.enabled=YES;
    self.DatePicker.hidden=YES;
    self.TimePicker.hidden=YES;
    self.TabBar.hidden=YES;
   }
}

- (IBAction)SelectBranch:(id)sender {
    
    [self.view endEditing:YES];
    [self Branch].enabled = NO;
    self.dropdownTable.hidden = NO;
    self.DatePicker.hidden=YES;
    self.TimePicker.hidden=YES;
    self.TabBar.hidden=YES;
    self.DateTime.text=nil;
    [self DateTime].enabled = YES;
}
- (IBAction)SubmitButton:(id)sender {
    
    [self.view endEditing:YES];
    if ([self.CPersons.text isEqualToString:@"0"])
    {
        self.CPersons.text=@"";
        [self showMessage:@"Invalid Data" :@"Please enter correct no of persons."];
    }
    else
    {
   if (!([self.CName.text isEqualToString:@""] || [self.CEmail.text isEqualToString:@"" ]  ||[self.CPersons.text isEqualToString:@""] ||[self.CPhoneNo.text isEqualToString:@""] ||[self.Branch.text isEqualToString:@""] ||[self.DateTime.text isEqualToString:@""]))
    {
        
        phone=self.CPhoneNo.text;
        persons=self.CPersons.text;
        email=self.CEmail.text;
        name=self.CName.text;
        [self PostData];
        
        defaults = [NSUserDefaults standardUserDefaults];
        branch=self.Branch.text;
        [Pdata addObject:branch];
        [Pdata addObject:time];
        NSObject * object = [defaults objectForKey:@"Reservations"];
        if(object == nil){
          
            Torders=[[NSMutableArray alloc] init];
            [Torders addObject:Pdata];
            [defaults setObject:Torders forKey:@"Reservations"];
        }
        
        else
        {
            Torders = [[defaults objectForKey:@"Reservations"]mutableCopy];
            [Torders addObject:Pdata];
            [defaults setObject:Torders forKey:@"Reservations"];
        }
    
        [defaults synchronize];
        [self EmptyFields];
        [self performSelector:@selector(goToNextView) withObject:nil ];
        
   }
       else
        [self.view makeToast:@"Please enter data correctly"];
    }
    
}
#pragma mark - Passing Data Through Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
         return NO;
 }
- (void)goToNextView {
    
    ismove=YES;
    
    [self showMessage:@"Confirmation" :@"Your reservation has been successfully placed! You will soon receive a confirmation call."];
   
    
}

#pragma mark - View's Own Methods

-(void)set
{
    self.CPersons.inputAccessoryView =[[GlobalVariables class]done:self.view];
    self.SButton.layer.cornerRadius = 5;
    self.SButton.clipsToBounds = YES;
    self.DatePicker.hidden=YES;
    self.TimePicker.hidden=YES;
    self.TabBar.hidden=YES;
    self.DoneButton.tintColor =[[GlobalVariables class]color:1];
    self.dropdownTable.hidden=YES;
    self.DateTime.delegate=self;
    [self.SButton setBackgroundColor: [[GlobalVariables class]color:1]];
       self.navigationItem.title= [[GlobalVariables class]Title:@"Reserve a Table" ];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    oldFrame.origin.y= self.view.frame.origin.y;
    self.Branch.rightViewMode = UITextFieldViewModeAlways;
    self.Branch.rightView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropDown"]];
    self.DateTime.rightViewMode = UITextFieldViewModeAlways;
    self.DateTime.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropDown"]];
    self.CName.delegate = self;
    self.CPhoneNo.delegate=self;
    self.CPersons.delegate=self;
    self.CEmail.delegate = self;
    self.Branch.delegate=self;
    self.DateTime.delegate=self;
    [self.TimePicker setDatePickerMode:UIDatePickerModeTime];
    [self.DatePicker setValue:[[GlobalVariables class]color:1] forKey:@"textColor"];
    [self.DatePicker setValue:[UIColor groupTableViewBackgroundColor] forKey:@"backgroundColor"];
    [self.TimePicker setValue:[[GlobalVariables class]color:1]  forKey:@"textColor"];
    [self.TimePicker setValue:[UIColor groupTableViewBackgroundColor] forKey:@"backgroundColor"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self maxmindate];

}

-(void) retriveData
{
    [DejalActivityView activityViewForView:self.dropdownTable withLabel:@"Loading Branches..." width:self.view.frame.size.width-self.view.frame.size.width/3];
    
    NSString *string = [NSString stringWithFormat:@"%@/branches", BaseUrl];
    NSURL *url = [NSURL URLWithString:string];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:DataType forHTTPHeaderField:CType];
    [manager.requestSerializer setValue:Key forHTTPHeaderField:Authorization];
    
     manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        BArray =[[NSMutableArray alloc]init];
        Json = (NSMutableArray *)responseObject;
        
        for(int i=0;i<Json.count;i++)
        {
            NSString *Name = [[Json objectAtIndex:i]valueForKey:NKey];
            NSString *CId = [[Json objectAtIndex:i]valueForKey:@"code"] ;
            Categories *Cobj=[[Categories alloc] initWithCId:CId andCName:Name];
            [BArray addObject:Cobj];
        }
        [self.dropdownTable reloadData];
         [DejalActivityView removeView];
               
    } failure:^(NSURLSessionTask *operation, NSError *error) {
      //  NSLog(@"Data retrived faild");
        [self.view makeToast:@"No Internet Connection"];
    }];
    
  
}

-(void)showMessage:(NSString*)Title :(NSString *)message
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:Title message:message  preferredStyle:UIAlertControllerStyleAlert];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertController dismissViewControllerAnimated:YES completion:^{
           
            if(ismove)
            {
                [self performSegueWithIdentifier:@"SubmitSegue" sender:self];
              
            }
        }];
        
    });

    [self presentViewController:alertController animated:YES completion:nil];
    
  
    
}

-(void) validTime
{
    
    if ([Bid isEqualToString:@"CF"] || [Bid isEqualToString:@"MAS"])
        [self startTime:12 endTime:23];
    else
        [self startTime:18 endTime:23];

}
-(void) EmptyFields
{
    self.CName.text=nil;
    self.CPhoneNo.text=nil;
    self.CPersons.text=nil;
    self.CEmail.text=nil;
    self.Branch.text=nil;
    self.DateTime.text=nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.DatePicker.hidden=YES;
    [self.view endEditing:YES];
}
-(void)show{
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon" ] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    
    self.navigationItem.title=[[GlobalVariables class]Title:@"Reserve A Table"];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];

}
-(void)startTime:(int)start endTime:(int) end
{
    
    int startHour = start;
    int endHour = end;
    
    NSDate *date1 = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian ];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date1];
    [components setHour: startHour];
    [components setMinute: 0];
    [components setSecond: 0];
    NSDate *startDate = [gregorian dateFromComponents: components];
    
    [components setHour:endHour];
    [components setMinute: 59];
    [components setSecond: 59];
    NSDate *endDate = [gregorian dateFromComponents: components];
    
    [self.TimePicker setMinimumDate:startDate];
    [self.TimePicker setMaximumDate:endDate];
    [self.TimePicker setDate:startDate animated:YES];
    [self.TimePicker reloadInputViews];
    

   }

- (BOOL)validateEmailWithString:(NSString*)email1
 {
 NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
 NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
 return [emailTest evaluateWithObject:email1];
 }

-(BOOL) day
{
     NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian ];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:self.DatePicker.date];
    int weekday =(int)[comps weekday];
    
    if (weekday == 1 ||weekday == 7 )
    {
    
       [self showMessage:@"Alert!" :@"Sorry you can't make reservation for weekends. Please select days except saturday and sunday"];
        return YES;
    }
   
    return NO;
}
-(void)maxmindate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    self.DatePicker.maximumDate=maxDate;
    self.TimePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
    [self.DatePicker setDatePickerMode:UIDatePickerModeDate];
    NSTimeInterval oneDay = 60 * 60 * 24;
    self.DatePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:oneDay * 2];
 
}
-(UIToolbar *) done
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                  target:self.view action:@selector(endEditing:)];
    doneBarButton.tintColor=[UIColor grayColor];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];

    return keyboardToolbar;
}
    @end
