//
//  MovieCell.h
//  RottenFruit
//
//  Created by Azai Chan on 6/17/15.
//  Copyright (c) 2015 Azai Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end
