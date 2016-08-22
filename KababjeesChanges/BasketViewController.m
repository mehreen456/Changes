 //
//  BasketViewController.m
//  Kababjee'sApp
//
//  Created by Amerald on 15/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "BasketViewController.h"

@interface BasketViewController ()
{
   UIButton *addProject;
   int t,m,j;
   NSInteger Price,totalPrice;
   BOOL deleteIT;
   UILabel *label;
}

@end

@implementation BasketViewController

@synthesize OrderTable,Button,AmountLabel1,AmountLabel2,PriceView,tapRecognizer,addbutn,chckbtn;

- (void)viewDidLoad {
    
    j=2, t=1, m=0;
    [super viewDidLoad];
    [self show];
   
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ItemsOrder.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    cell.Quantity.text=[[ItemsOrder objectAtIndex:indexPath.row]valueForKey:QKey ];
    cell.OrderLabel.text=[@" x " stringByAppendingString:[[ItemsOrder objectAtIndex:indexPath.row]valueForKey:INKey]];
    Price=[[[ItemsOrder objectAtIndex:indexPath.row]valueForKey:IPKey ]integerValue];
    NSInteger oldqun=[[[ItemsOrder objectAtIndex:indexPath.row]valueForKey:QKey ]integerValue];
    totalPrice= Price*oldqun;
    cell.OrderPriceLabel.text=[NSString stringWithFormat:@"%ld", (long)totalPrice];
    cell.Quantity.delegate=self;
    
    if (j==1)
        [[cell.contentView viewWithTag:201] setHidden:NO];
    
    if(j==0)
        [[cell.contentView viewWithTag:201] setHidden:YES];
   
    if(j==2 && m<ItemsOrder.count)
    {
        m++;
        addProject = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        addProject.frame = CGRectMake(self.view.frame.size.width-20, cell.OrderPriceLabel.frame.origin.y+5, 15, cell.OrderPriceLabel.frame.size.height-10);
            addProject.backgroundColor=[UIColor clearColor];
        UIImage * buttonImage = [UIImage imageNamed:@"Delete"];
        [addProject setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [addProject addTarget:self action:@selector(OrderRemove:) forControlEvents:UIControlEventTouchUpInside];
        addProject.tag=201;
        [cell.contentView addSubview:addProject];
        [[cell.contentView viewWithTag:201] setHidden:YES];
       
      }
  
    return cell;
}


#pragma mark - UITextFieldDelegate

 - (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.OrderTable];
    NSIndexPath * indexPath = [self.OrderTable indexPathForRowAtPoint:point];
    
    NSInteger newQ=[textField.text integerValue];
    if(newQ==0)
    {
        NSInteger diff=[TPrice integerValue]-Price;
        TPrice=[NSString stringWithFormat:@"%2lu", (unsigned long)diff];
        [ItemsOrder removeObjectAtIndex:indexPath.row];
    }
    else
    [[ItemsOrder objectAtIndex:indexPath.row] setValue:[NSString stringWithFormat:@"%ld", (long)newQ] forKey:QKey];
    [OrderTable reloadData];
    [self change];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
if(j==1)
{
    return YES;
}
else
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([currentString length] > 4) {
     
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        UIView *new=[[UIView alloc]init];
        new.backgroundColor=[UIColor clearColor];
        [window addSubview:new];
        [window makeToast:@"Can't Enter More Quantity"];
        [new removeFromSuperview];
         return NO;
    }
    return YES;
}

#pragma mark - ViewButtons

- (IBAction)MyButton:(id)sender
{
   
    if ([Button.titleLabel.text isEqualToString: @"APPLY CHANGES"])
    {
        j=0;
        [Button setTitle:@"EDIT ORDER" forState:UIControlStateNormal];
        [Button setTintColor:[UIColor blueColor]];
    }
    else
    {
         j=1;
        [Button setTitle:@"APPLY CHANGES" forState:UIControlStateNormal];
        [Button setTintColor:[UIColor redColor]];
    }
    
    [OrderTable reloadData];
  
}

-(void)OrderRemove:(UIButton *) sender
{
    if(j==1)
     {
        UITableViewCell *mycell= (UITableViewCell *)[[sender superview] superview];
        NSIndexPath *ind= [self.OrderTable indexPathForCell:mycell];
        [ItemsOrder removeObjectAtIndex:ind.row];
        [self.view makeToast:@"Item Deleted"];
        NSInteger diff=[TPrice integerValue]-totalPrice;
        TPrice=[NSString stringWithFormat:@"%2lu", (unsigned long)diff];
         [OrderTable reloadData];
         [self change];
         
    }
}

- (IBAction)CheckOutButton:(id)sender {
    
    if(ItemsOrder.count==0 )
      [self performSegueWithIdentifier:@"GoToMain" sender:self];
}

#pragma mark - SegueMethod

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
   if([identifier isEqualToString:@"GoToMain"])
            return YES;
   
    else if ([identifier isEqualToString:@"GoToProceed"])
    { if(ItemsOrder.count>0 && ![TPrice isEqual:@"00"])
       return YES;
        return NO;
     }
    else if ([identifier isEqualToString:@"EToMain"])
    {
       if(ItemsOrder.count==0)
        return YES;
        return NO;
    }
    else
        return NO;
}

#pragma mark - View Own Methods

- (void)didTapAnywhere:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
-(void) change
{   btp=0;
    for(int k=0; k<ItemsOrder.count;k++)
    {
        NSInteger price =[[[ItemsOrder objectAtIndex:k]valueForKey:IPKey ]integerValue];
        NSInteger quantity =[[[ItemsOrder objectAtIndex:k]valueForKey:QKey ]integerValue];
        NSInteger basketPrice= price*quantity;
        btp=btp + basketPrice;
        TPrice=[NSString stringWithFormat:@"%02lu", (unsigned long)btp];
    }
   
        UIView* BLView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 50)];
        UIButton *basket=[[GlobalVariables class]BarButton];
        basket.frame = BLView.frame;
        [BLView addSubview:basket];
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:BLView];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        self.navigationItem.rightBarButtonItem.enabled = NO;
       if(ItemsOrder.count==0)
       {
           BasketItems=0;
           TPrice=@"00";
           self.navigationItem.rightBarButtonItem=nil;
        
       }
        AmountLabel1.text=[@"Rs. " stringByAppendingString:TPrice];
        AmountLabel2.text=[@"Rs. " stringByAppendingString:TPrice];
   
 
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

-(void) show
{
    AmountLabel1.text=[@"Rs. " stringByAppendingString:TPrice];
    AmountLabel2.text=[@"Rs. " stringByAppendingString:TPrice];
    [self AddBorders];
    [self navigation];
    [self setcolor];
    [self Tap];
}
-(void)Tap
{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];

}
-(void) setcolor
{
    [self.Button  setTitleColor:[[GlobalVariables class]color:0] forState:UIControlStateNormal ];
    [self.addbutn setTitleColor:[[GlobalVariables class]color:0] forState:UIControlStateNormal ];
    
    [self.chckbtn setBackgroundColor: [[GlobalVariables class]color:1]];
    
}
-(void) navigation
{
    self.navigationItem.title= [[GlobalVariables class]Title:@"Checkout" ];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Place Order" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
-(void)AddBorders
{
    UIView *topBorder = [UIView new];
    topBorder.backgroundColor = [UIColor lightGrayColor];
    topBorder.frame = CGRectMake(0, 0,self.view.frame.size.width, 2);
    [PriceView addSubview:topBorder];
    UIView *bottomBorder = [UIView new];
    bottomBorder.backgroundColor = [UIColor lightGrayColor];
    bottomBorder.frame = CGRectMake(0, self.PriceView.frame.size.height - 2, self.view.frame.size.width,2);
    [PriceView addSubview:bottomBorder];
    
}
@end
