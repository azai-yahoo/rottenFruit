//
//  ViewController.m
//  RottenFruit
//
//  Created by Azai Chan on 6/12/15.
//  Copyright (c) 2015 Azai Chan. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController


- (NSString *)convertPosterUrlStringToHighRes: (NSString *)urlString {
    NSRange range = [urlString rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *returnValue = urlString;
    if (range.length > 0) {
        returnValue = [urlString stringByReplacingCharactersInRange:range withString: @"https://content6.flixster.com/"];
    }
    return returnValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    NSString *posterURLString = [self.movie valueForKeyPath:@"posters.detailed"];
    NSString *posterURLStringHiRes = [self convertPosterUrlStringToHighRes:posterURLString];

    [self.posterView setImageWithURLRequest:([NSURLRequest requestWithURL:[NSURL URLWithString:posterURLString]]) placeholderImage:nil
        success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ) {
            self.posterView.alpha = 0.0;
            self.posterView.image = image;
            [UIView animateWithDuration:0.25
                 animations:^{
                     self.posterView.alpha = 1.0;
                 }
            ];

        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }
    ];
    // Apply hi-resolution poster
    [self.posterView setImageWithURL:[NSURL URLWithString:posterURLStringHiRes]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
