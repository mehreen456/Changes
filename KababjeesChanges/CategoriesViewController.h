//
//  CategoriesViewController.h
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "Categories.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "ReservationViewController.h"

@interface CategoriesViewController : UIViewController <UIScrollViewDelegate,SKSTableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTable1;
@property (strong, nonatomic) IBOutlet UIView *myview;
@property (strong, nonatomic) IBOutlet UIView *HeaderView;
@property (strong, nonatomic) IBOutlet SKSTableView *myTable;
@property (nonatomic,strong) NSMutableArray * CategoriesArray, *Json;

-(void) retriveData;

@end
