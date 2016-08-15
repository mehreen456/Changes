//
//  MyTableViewCell.m
//  ResturantApp
//
//  Created by Amerald on 18/06/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

@synthesize nameLabel = _nameLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize priceLabel=_priceLabel;
@synthesize ActivityInd;
@synthesize thumbnailImageView = _thumbnailImageView;

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
