//
//  MenuItemsViewController.m
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "MenuItemsViewController.h"


@interface MenuItemsViewController ()
@end

@implementation MenuItemsViewController
{
    CGFloat Dlwidth,NLwidth;
    int Dlines;
    UIBarButtonItem* rightBarButton,*menu;
    NSString *ImageUrl;
    BOOL Do;
}
@synthesize menuTable,JsonRes,CImage;

- (void)viewDidLoad {
    
    [self show];
    [super viewDidLoad];
    if(Relaod==0)
     {
        MenuArray =[[NSMutableArray alloc]init];
        [self retriveData];
     }
    if([TPrice isEqualToString:@"00"]||[TPrice isEqualToString:@"0"]  || ItemsOrder.count==0)
    {
        [self EmptyArray];
    }

}
#pragma mark - UITableDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        [tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MenuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   
    return NLwidth+Dlines+20 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
      return 10.;
    
    else
      return 20.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
   [self performSegueWithIdentifier:@"MSegue" sender:tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     Do=YES;
    static NSString *simpleTableIdentifier = @"MyTableCell";
    
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    MenuItems *currentCat=[MenuArray objectAtIndex:indexPath.section];
   
   
    cell.thumbnailImageView.image=[UIImage imageNamed:@"logo.png"];
    cell.backgroundColor = [UIColor colorWithRed:1. green:1. blue:1. alpha:0.5];
       CGSize textSize = [currentCat.MIdescrp sizeWithAttributes:@{NSFontAttributeName:[cell.descriptionLabel font]}];
    CGFloat strikeWidth = textSize.width;
    Dlines=(strikeWidth/cell.descriptionLabel.frame.size.width+1)*25;
    CGSize textSize2 = [currentCat.MIname sizeWithAttributes:@{NSFontAttributeName:[cell.nameLabel font]}];
    CGFloat strikeWidth2 = textSize2.width;

    NLwidth=strikeWidth2/cell.nameLabel.frame.size.width;
    if(NLwidth<=1)
           NLwidth=25;
   
    else
           NLwidth=50;
    

    cell.nameLabel.frame=CGRectMake(cell.nameLabel.frame.origin.x,cell.frame.origin.y+10, cell.nameLabel.frame.size.width, NLwidth);
    
    cell.descriptionLabel.frame=CGRectMake(cell.descriptionLabel.frame.origin.x,cell.nameLabel.frame.origin.y+NLwidth, cell.descriptionLabel.frame.size.width, Dlines);
    cell.nameLabel.text =currentCat.MIname ;
    cell.descriptionLabel.text = currentCat.MIdescrp;
    cell.priceLabel.text= [@"Rs " stringByAppendingString:currentCat.MIprice];
    
   
    return cell;
}

#pragma mark - My Methods

-(void)retriveData
{
    [DejalActivityView activityViewForView:self.view withLabel:@"Loading ..." width:self.view.frame.size.width-self.view.frame.size.width/2];
    
    NSString *string =[NSString stringWithFormat:@"%@/menus", BaseUrl];
    NSURL *url = [NSURL URLWithString:string];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:DataType forHTTPHeaderField:CType];
    [manager.requestSerializer setValue:Key forHTTPHeaderField:Authorization];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        JsonRes = (NSMutableArray *)responseObject;
        
        for(int i=0;i<JsonRes.count;i++)
        {
            NSString *MId = [[[JsonRes objectAtIndex:i]valueForKey:IdKey]stringValue];
            
           if([MId isEqualToString:CID])
          {
            NSString *MIname = [[JsonRes objectAtIndex:i]valueForKey:NKey];
            
            NSString *MIdescrp = [[JsonRes objectAtIndex:i]valueForKey:DesKey];
            
            NSString *MIprice = [[[JsonRes  objectAtIndex:i]valueForKey:PKey]stringValue];
            NSArray *img=[[JsonRes objectAtIndex:i]valueForKey:ImgKey];
            if(img.count==0)
            ImageUrl=nil;
            else
            ImageUrl=[[img objectAtIndex:0]valueForKey:@"url"];
            
            MenuItems *MCobj= [[MenuItems alloc] initWithMIprice:MIprice andMIname:MIname andMIdescrp:MIdescrp andImageUrl:ImageUrl andMId:(NSString *) MId];
            [MenuArray addObject:MCobj];
              
            }
        }
        
        [self.menuTable reloadData];
        [DejalActivityView removeView];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
       NSLog(@" Menu Data retrived faild");
       [self.view makeToast:@"No Internet Connection"];
}];
   
}

-(void) basket
{
    [self performSegueWithIdentifier:@"BSegue" sender:self.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [self.navigationController.navigationBar setBackgroundColor: [[GlobalVariables class]color:0]];
            [navController setViewControllers: @[dvc] animated: NO ];
            dvc.navigationItem.leftBarButtonItem= menu;
            dvc.navigationItem.rightBarButtonItem=rightBarButton;
            dvc.navigationItem.title=@"Checkout";
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
            
        };
    }

    else
    {
            NSIndexPath *indexPath = [self.menuTable indexPathForSelectedRow];
            ItemDescriptionViewController *destViewController = segue.destinationViewController;
            MenuItems *m1= [MenuArray objectAtIndex:indexPath.section];
            destViewController.Name = m1.MIname;
            destViewController.Price=m1.MIprice;
            destViewController.imageUrl=m1.MImg;
            destViewController.ItemID=m1.MId;
            destViewController.navigationItem.rightBarButtonItem=rightBarButton;
    }

}

-(void) show
{
    
    if(BasketItems>0)
    {
        UIView* BLView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 50)];
        UIButton *basket=[[GlobalVariables class]BarButton];
        basket.frame = BLView.frame;
        [basket addTarget:self action:@selector(basket) forControlEvents:UIControlEventTouchUpInside];
        [BLView addSubview:basket];
        
        rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:BLView];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
   
    menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon" ] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
   
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.title=CTitle;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
     UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BAckground"]];
    [tempImageView setFrame:self.menuTable.frame];
    
    self.menuTable.backgroundView = tempImageView;
   
}
-(void) EmptyArray
{
        TPrice=@"00";
        BasketItems=0;
        [ItemsOrder removeAllObjects];
        self.navigationItem.rightBarButtonItem=nil;
   
}
@end
