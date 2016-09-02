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
    NSDateFormatter *dateFormatter;
    CGRect oldFrame;
    NSMutableArray *Json;
    NSString *Bid,*email,*persons,*name,*datetime,*phone,*AvailableTime;
    NSDictionary *jsonDictionary;
    NSDate *mydate;
    int timestamp,move;
}
@end

@implementation ReservationViewController
@synthesize DateTime,DatePicker,Branch,BArray,dropdownTable,CName,CPersons,CPhoneNo,CEmail,SButton;
- (void)viewDidLoad {
     move=0;
    [self DateTime].enabled = NO;
    [super viewDidLoad];
    [self set];
    [self retriveData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
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
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
   
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Categories *c1= [BArray objectAtIndex:indexPath.row];
    Bid=c1.CId;
    self.Branch.text=c1.CName;
    if([Bid isEqualToString:@"1"] || [Bid isEqualToString:@"2"] || [Bid isEqualToString:@"3"] || [Bid isEqualToString:@"4"] || [Bid isEqualToString:@"6"])
        self.DateTime.placeholder=@"Timings 6:59 pm to 12:59 am";
    
    if([Bid isEqualToString:@"5"] || [Bid isEqualToString:@"7"])
        self.DateTime.placeholder=@"Timings 12 pm to 12 am";

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
        move=1;
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.CName)
        [self.CEmail becomeFirstResponder];
    
    else if (textField == self.CEmail)
        [self.CPhoneNo becomeFirstResponder];
    
    else if (textField == self.CPhoneNo)
        [self.CPersons becomeFirstResponder];
    
    else
        [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.15 animations:^
     {
         if(move==1)
         {
             CGRect newFrame = [self.view frame];
             newFrame.origin.y -= 70;
             newFrame.size.height+=50;
             [self.view setFrame:newFrame];
         }
         else
         {
         CGRect newFrame = [self.view frame];
         newFrame.origin.y -= 30;
         newFrame.size.height+=30;
         [self.view setFrame:newFrame];
         }
         
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
    
    jsonDictionary =@{@"time": datetime,
                      @"no_of_person":persons,
                      @"phone":phone,
                      @"name":name,
                      @"branch_id":Bid,
                      @"email": email,
                      };
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody:jsonData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                          NSLog(@"Error ... ");
                                          return;
                                      }
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response Body:\n%@\n", body);
                                  }];
    [task resume];
}

#pragma mark - Buttons Function

- (IBAction)DateTime:(id)sender {
    
    self.DateTime.text=nil;
    dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    self.DatePicker.hidden=NO;
    self.TabBar.hidden=NO;
    
}

- (IBAction)CloseDatePicker:(id)sender {
    
    if([self validTime])
        return;
    self.DateTime.text=[NSString stringWithFormat:@"%@" ,[dateFormatter stringFromDate:self.DatePicker.date]];
    NSDateFormatter * dateFormatter1 = [[NSDateFormatter alloc] init] ;
    [dateFormatter1 setDateFormat:@"dd/MM/yyyy HH:mm"] ;
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter1 setTimeZone:gmt];
    NSDate *date = [dateFormatter1 dateFromString:self.DateTime.text] ;
    NSTimeInterval interval  = [date timeIntervalSince1970] ;
    datetime= [NSString stringWithFormat:@"%f", interval];
    self.DatePicker.hidden=YES;
    self.TabBar.hidden=YES;
    
}

- (IBAction)SelectBranch:(id)sender {
    
    [self.view endEditing:YES];
    [self Branch].enabled = NO;
    self.dropdownTable.hidden = NO;
    self.DatePicker.hidden=YES;
    self.DateTime.text=nil;
     [self DateTime].enabled = YES;
}
- (IBAction)SubmitButton:(id)sender {
    
    [self.view endEditing:YES];
    
    if (!([self.CName.text isEqualToString:@""] || [self.CEmail.text isEqualToString:@"" ]  ||[self.CPersons.text isEqualToString:@""] ||[self.CPhoneNo.text isEqualToString:@""] ||[self.Branch.text isEqualToString:@""] ||[self.DateTime.text isEqualToString:@""]))
    {
        phone=self.CPhoneNo.text;
        persons=self.CPersons.text;
        email=self.CEmail.text;
        name=self.CName.text;
        [self PostData];
        [self showMessage];
        
   }
    
}
#pragma mark - Passing Data Through Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (([self.CName.text isEqualToString:@""] || [self.CEmail.text isEqualToString:@"" ]  ||[self.CPersons.text isEqualToString:@""] ||[self.CPhoneNo.text isEqualToString:@""] ||[self.Branch.text isEqualToString:@""] ||[self.DateTime.text isEqualToString:@""]))
         [self.view makeToast:@"Please enter data correctly"];
    else
         [self EmptyFields];
    
    return NO;
}
- (void)goToNextView {
    
    [self performSegueWithIdentifier:@"SubmitSegue" sender:self];
}


#pragma mark - View's Own Methods


-(void)set
{
    self.DatePicker.hidden=YES;
    self.TabBar.hidden=YES;
    self.dropdownTable.hidden=YES;
    self.DateTime.delegate=self;
    [self.SButton setBackgroundColor: [[GlobalVariables class]color:1]];
    self.DatePicker.minimumDate = [NSDate date];
    self.DatePicker.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title= [[GlobalVariables class]Title:@"Reserve a Table" ];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    oldFrame.origin.y= self.view.frame.origin.y;
    self.Branch.rightViewMode = UITextFieldViewModeAlways;
    self.Branch.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropDown"]];
    self.DateTime.rightViewMode = UITextFieldViewModeAlways;
    self.DateTime.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropDown"]];
    self.CName.delegate = self;
    self.CPhoneNo.delegate=self;
    self.CPersons.delegate=self;
    self.CEmail.delegate = self;
    self.Branch.delegate=self;
    self.DateTime.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    self.DatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
}

-(void) retriveData
{
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
            NSString *CId = [[[Json objectAtIndex:i]valueForKey:IKey ]stringValue] ;
            Categories *Cobj=[[Categories alloc] initWithCId:CId andCName:Name];
            [BArray addObject:Cobj];
        }
        [self.dropdownTable reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Data retrived faild");
        [self.view makeToast:@"No Internet Connection"];
    }];
}

-(void)showMessage
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Your reservation has been successfully placed! You will soon receive a confirmation call." preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertController dismissViewControllerAnimated:YES completion:^{
            [self performSelector:@selector(goToNextView) withObject:nil ];
            
        }];
        
    });
    
}

-(BOOL) validTime
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[self.DatePicker date]];
    if ([Bid isEqualToString:@"1"] ||[Bid isEqualToString:@"3"] ||[Bid isEqualToString:@"6"] ||[Bid isEqualToString:@"4"] || [Bid isEqualToString:@"2"])
    {
        
      if (!(([dateComponents hour] >18 && [dateComponents hour]<=23) || ([dateComponents hour] ==18 && [dateComponents minute]== 59 ) || ([dateComponents hour] ==00 && [dateComponents minute]<59 ))){
        
        [self.DatePicker makeToast:@"Invalid Timings"];
        return YES;
    }
    }
   
    if ([Bid isEqualToString:@"7"] || [Bid isEqualToString:@"5"])
    {
        if (!(([dateComponents hour] >=12 && [dateComponents hour]<=23) || ([dateComponents hour] ==00 && [dateComponents minute]==00 ))){
            
            [self.DatePicker makeToast:@"Invalid Timings"];
            return YES;
        }
    }
   
           return NO;
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
@end
