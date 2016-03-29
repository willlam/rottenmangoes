//
//  CollectionViewController.m
//  rottenmangoes
//
//  Created by William Lam on 2016-03-28.
//  Copyright © 2016 William Lam. All rights reserved.
//

#import "CollectionViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "DetailViewController.h"

@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) int maxNum;
@property (nonatomic, assign) int pageNum;

@end

@implementation CollectionViewController

static NSString *ROTTEN_TOMATO_APIKEY = @"j9fhnct2tp8wu2q9h75kanh9";

//static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.objects = [[NSMutableArray alloc] init];
	self.pageNum = 1;
	
	[self loadData];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

	return self.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	Movie *movie = self.objects[indexPath.row];
	
	cell.titleLabel.text = movie.title;
	cell.movieIDLabel.text = movie.movieID;
	cell.moviePhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:movie.photo]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == self.objects.count - 1) {
		if (self.objects.count < self.maxNum) {
			self.pageNum++;
			[self loadData];
		}
	}
	
}

#pragma mark - Load Data

- (void) loadData {
	NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=j9fhnct2tp8wu2q9h75kanh9&page_limit=50&page=1"];
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	
	NSURLSession *session = [NSURLSession sharedSession];
	
	NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (!error) {
			
			NSError *jsonError;
			NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
			if (!jsonError) {
				
				NSLog(@"%@", jsonData);
				
				self.maxNum = [jsonData[@"total"] intValue];
				
				for (NSDictionary *movieDictionary in jsonData[@"movies"]) {
					Movie *movie = [[Movie alloc] init];
					movie.title = movieDictionary[@"title"];
					movie.movieDescription = movieDictionary[@"synopsis"];
					movie.photo = movieDictionary[@"posters"][@"original"];
					movie.movieID = movieDictionary[@"id"];
					
					[self.objects addObject:movie];
				}
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.collectionView reloadData];
				});
			}
		}
	}];
	[dataTask resume];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
