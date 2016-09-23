//
//  CheckOutViewController.m
//  Kababjee'sApp
//
//  Created by Amerald on 19/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "CheckOutViewController.h"

@interface CheckOutViewController ()
{
    int key,hide;
    BOOL exist;
    NSData *kj;
    NSString *name,*address,*time,*num;
    NSInteger i;
    NSNumber *contact;
    NSDictionary *jsonDictionary;
    CGRect oldFrame ;
    CGSize kbSize;
    CGPoint kbposi;
    UIView  *subv;
    NSMutableArray *User,*UserInfo;
}

@end

@implementation CheckOutViewController
@synthesize customview,PButton,toastview;
@synthesize NameField = _NameField;
@synthesize ContactField = _ContactField;
@synthesize AddressField = _AddressField;

- (void)viewDidLoad
{
    key=1;exist=NO;
    [super viewDidLoad];
    oldFrame.origin.y= self.view.frame.origin.y;
    oldFrame.size.height= self.view.frame.size.height;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.PButton setBackgroundColor: [[GlobalVariables class]color:1]];
     self.navigationItem.title= [[GlobalVariables class]Title:@"Place Order" ];
    self.PButton.layer.cornerRadius = 5;
    self.PButton.clipsToBounds = YES;
     UserInfo=[[NSMutableArray alloc]init];
    _ContactField.inputAccessoryView=[[GlobalVariables class]done:self.view];
    
    _NameField.delegate = self;
    _ContactField.delegate=self;
    _AddressField.delegate=self;
 
}

#pragma mark - Post Data Through API

-(void) PostData
{
    NSString *string = [NSString stringWithFormat:@"%@/orders", BaseUrl];
    NSURL *URL = [NSURL URLWithString:string];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:DataType forHTTPHeaderField:CType];
    [request setValue:Key forHTTPHeaderField:Authorization];
    
    jsonDictionary =@{NKey: name,
                      @"phone":num,
                      @"address":address,
                      @"order_total":TPrice,
                      @"order_time": time,
                      @"device_os": @2,
                      @"order_detail": ItemsOrder
                      };

    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
   
    [request setHTTPBody:jsonData];
    [UserInfo addObject:jsonDictionary];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                       //   NSLog(@"Error ... ");
                                          return;
                                      }
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                       //   NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                        //  NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                     // NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                    //  NSLog(@"Response Body:\n%@\n", body);
                                  }];
    [task resume];
}

#pragma mark - Getting System Time

-(NSString *) time
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:now];
}

#pragma mark - View Button

- (IBAction)ProceedButton:(id)sender {
  
    
   if (!([self.NameField.text isEqualToString:@""] || [self.ContactField.text isEqualToString:@"" ]  ||[self.AddressField.text isEqualToString:@""] ))
   {
    name=self.NameField.text;
    num=self.ContactField.text;
    address=self.AddressField.text;
    time=[self time];
   [self PostData];
    
    defaults = [NSUserDefaults standardUserDefaults];
    [ItemsOrder addObject:TPrice];
       
       NSObject *obj=[defaults objectForKey:@"UCInfo"];
       if(obj == nil){
           
           User =[[NSMutableArray alloc] init];
           [User addObject:UserInfo];
           [defaults setObject:User forKey:@"UCInfo"];
       }
       
       else
       {
               User = [[defaults objectForKey:@"UCInfo"]mutableCopy];
               NSInteger sum =User.count;
               for(i=sum-1;i>=0;i--)
               {
                 NSString *Uname=[[[User objectAtIndex:i]objectAtIndex:0] valueForKey:NKey];
                 NSString *Iname=self.NameField.text;
                 if ([Uname isEqualToString:Iname])
                 {
                   NSString *Uphone=[[[User objectAtIndex:i]objectAtIndex:0] valueForKey:@"phone"];
                   NSString *Uemail=[[[User objectAtIndex:i]objectAtIndex:0] valueForKey:@"address"];
                   NSString *Iphone=self.ContactField.text;
                                     NSString *Iadd=self.AddressField.text;
                   if ([Uname isEqualToString:Iname] && [Uphone isEqualToString:Iphone] && [Uemail isEqualToString:Iadd]) {
                       exist=YES;
                       break;
                   }
                }
              }
              if(!exist)
              {
               [User addObject:UserInfo];
               [defaults setObject:User forKey:@"UCInfo"];
               }
        }


    NSObject * object = [defaults objectForKey:@"Orders"];
       if(object == nil){
           
           Torders=[[NSMutableArray alloc] init];
           [Torders addObject:ItemsOrder];
           [defaults setObject:Torders forKey:@"Orders"];
       }
       
       else
       {
           Torders = [[defaults objectForKey:@"Orders"]mutableCopy];
           [Torders addObject:ItemsOrder];
           [defaults setObject:Torders forKey:@"Orders"];
    }
    [defaults synchronize];
    [self performSelector:@selector(goToNextView) withObject:nil ];
   }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.NameField)
     [self.ContactField becomeFirstResponder];
   
    else if (textField == self.ContactField)
       [self.AddressField becomeFirstResponder];
    
    else
       [textField resignFirstResponder];
   
    return YES;
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==self.AddressField)
    {
        CGRect newFrame = [self.view frame];
        newFrame.origin.y -= 30;
        [self.view setFrame:newFrame];

    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField==self.NameField)
    {
        defaults = [NSUserDefaults standardUserDefaults];
        NSString *Iname=self.NameField.text;
        User = [defaults objectForKey:@"UCInfo"];
        NSInteger sum =User.count;
        for(i=sum-1;i>=0;i--)
        {
            NSString *Uname=[[[User objectAtIndex:i]objectAtIndex:0] valueForKey:NKey];
            
            if ([Uname isEqualToString:Iname]) {
                self.ContactField.text=[[[User objectAtIndex:i]objectAtIndex:0] valueForKey:@"phone"];
                self.AddressField.text=[[[User objectAtIndex:i] objectAtIndex:0] valueForKey:@"address"];
                break;
            }
        }
    }
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
     [self.view endEditing:YES];
    }

#pragma mark - Passing Data Through Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self.view endEditing:YES];
   if (([self.NameField.text isEqualToString:@""] || [self.ContactField.text isEqualToString:@"" ]  ||[self.AddressField.text isEqualToString:@""] ))
    {
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        UIView *new=[[UIView alloc]init];
        new.backgroundColor=[UIColor clearColor];
        [window addSubview:new];
        [window makeToast:@"Please fill all mandatory fields"];
        [new removeFromSuperview];
        return NO;
    }
        return NO;
    
}
- (void)goToNextView {
    
    [self performSegueWithIdentifier:@"TySegue" sender:self];
}

@end
