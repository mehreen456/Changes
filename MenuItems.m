//
//  MenuItems.m
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "MenuItems.h"

@implementation MenuItems
@synthesize MIprice , MIname, MIdescrp,MImg,MId;

-(id) initWithMIprice: (NSString *) IP andMIname: (NSString *) IN andMIdescrp:(NSString *) ID andImageUrl:(NSString *) Img andMId:(NSString *) Id;
{
    self=[super init];
    {
    MIprice=IP;
    MIname=IN;
    MIdescrp=ID;
    MImg=Img;
    MId=Id;
        
    }
    return self;

}

@end
