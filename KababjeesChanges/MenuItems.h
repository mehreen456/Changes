//
//  MenuItems.h
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItems : NSObject

@property(nonatomic,strong) NSString * MIprice;
@property(nonatomic,strong) NSString * MIname;
@property(nonatomic,strong) NSString * MIdescrp;
@property(nonatomic,strong) NSString *MImg;
@property(nonatomic,strong) NSString  *MId;

-(id) initWithMIprice: (NSString *) IP andMIname: (NSString *) IN andMIdescrp:(NSString *) ID andImageUrl:(NSString *) MImg andMId:(NSString *) MId;
@end
