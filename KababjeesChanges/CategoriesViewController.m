
//  CategoriesViewController.m
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "CategoriesViewController.h"

@interface CategoriesViewController ()

@property (nonatomic, strong) NSArray *contents;

@end

@implementation CategoriesViewController

@synthesize CategoriesArray,myTable,HeaderView,Json;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.myTable.frame=CGRectMake(0, 0, 0, 0);
    self.myTable.SKSTableViewDelegate = self;
    ItemsOrder =[[NSMutableArray alloc]init];
    [self retriveData];
    self.view.backgroundColor=[UIColor blackColor];
    Running=NO;
}


#pragma mark - UITableViewDelegate
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (NSArray *)contents
{
    if (!_contents && CategoriesArray!=nil)
    {
        
        _contents = @[
                      @[
                          @[@"Online Order", @"My Order",@"My Reservation"],
                          @[@"Reservation",@"Make Reservation"],
                          @[@"Menu",CategoriesArray]]
                      ];
    }
    else {
        
        
    }
   
    return _contents;
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contents count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents[section] count];

}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==2)
        return self.CategoriesArray.count;
  
    else

    return [self.contents[indexPath.section][indexPath.row] count] - 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
   return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [myTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    cell.expandable = YES;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CCELL";
    
    UITableViewCell *cell = [myTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(indexPath.section==0 && indexPath.row==2)
    {
        Categories *currentCat=[CategoriesArray objectAtIndex:indexPath.subRow-1];
        cell.textLabel.text=currentCat.CName ;
    }
    
    else
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==2)
    {
    Categories *c1= [CategoriesArray objectAtIndex:indexPath.subRow-1];
    CID=c1.CId;
    CTitle=c1.CName;
    [self performSegueWithIdentifier:@"Menu" sender:self];
 
    }
   if(indexPath.section==0 && indexPath.row==1)
    [self performSelector:@selector(goToNextView) withObject:nil ];
    
   if(indexPath.section==0 && indexPath.row==0 && indexPath.subRow==1)
        [self performSegueWithIdentifier:@"MYOrder" sender:self];
   if(indexPath.section==0 && indexPath.row==0 && indexPath.subRow==2)
        [self performSegueWithIdentifier:@"MyReservation" sender:self];
    
}

#pragma mark - Actions

- (void)collapseSubrows
{
    [self.myTable collapseCurrentlyExpandedIndexPaths];
}

#pragma mark - Load Data Through API

-(void) retriveData
{
    NSString *string = [NSString stringWithFormat:@"%@/categories", BaseUrl];
    NSURL *url = [NSURL URLWithString:string];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:DataType forHTTPHeaderField:CType];
    [manager.requestSerializer setValue:Key forHTTPHeaderField:Authorization];
   
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        Json = (NSMutableArray *)responseObject;
        CategoriesArray =[[NSMutableArray alloc]init];
        
        for(int i=0;i<Json.count;i++)
        {
            NSString *CName = [[Json objectAtIndex:i]valueForKey:NKey];
            NSString *CId = [[[Json objectAtIndex:i]valueForKey:IKey ]stringValue] ;
            Categories *Cobj=[[Categories alloc] initWithCId:CId andCName:CName];
            
           [CategoriesArray addObject:Cobj];
        }
             SWRevealViewController *sv=self.revealViewController;
             [sv revealToggle:self];
     
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Data retrived faild");
        [self.view makeToast:@"No Internet Connection"];
    }];
    [self.myTable reloadData];
    if(_contents==nil)
    {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:@"Sorry! There is some problem in retriving data. You may call 111-666-111 to place your order." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    }
   
     }

#pragma mark - Passing Data Through Segue
-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
  return NO;

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
      if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        Relaod=0;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
  
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController.navigationBar setBackgroundColor: [[GlobalVariables class]color:0]];
                       [navController setViewControllers: @[dvc] animated: YES ];
                       [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            showmenu=YES;

                 };
}
    
}
- (void)goToNextView {
   
    [self performSegueWithIdentifier:@"Reservation" sender:self];
}
#pragma mark - Delegate Methods


-(void)viewWillDisappear:(BOOL)animated
{
     [self.myTable deselectRowAtIndexPath:[self.myTable indexPathForSelectedRow] animated:NO];
      [self.myTable setContentOffset:CGPointZero animated:NO];
    
}


@end
