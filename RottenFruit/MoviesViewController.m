//
//  MoviesViewController.m
//  RottenFruit
//
//  Created by Azai Chan on 6/16/15.
//  Copyright (c) 2015 Azai Chan. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refresh;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // pull-to-refresh
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.tintColor = [UIColor grayColor];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh..."];
    [self.refresh addTarget:self action:@selector(requestAPIForMovies) forControlEvents:UIControlEventValueChanged];

    tableViewController.refreshControl = self.refresh;

    // END pull-to-refresh
    
    [self requestAPIForMovies];
}

- (void)requestAPIForMovies {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *apiURLString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiURLString]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = dict[@"movies"];
            [self.tableView reloadData];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refresh endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Return rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] init]; // Create new row when scroll
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];

    NSString *posterUrlString = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrlString]];
//    NSLog(@"Row %ld", (long)indexPath.row);
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MovieCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *movie = self.movies[indexPath.row];
    ViewController *destinationVC = segue.destinationViewController;
    destinationVC.movie = movie;
}

@end
