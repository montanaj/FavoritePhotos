//
//  CMJViewController.m
//  FavoritePhotos
//
//  Created by Claire Jencks on 3/31/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//  API Key b540bffdef2e4be5e90462d0c2bf7cbf

#import "CMJViewController.h"
#import "CollectionViewCell.h"


@interface CMJViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITabBarControllerDelegate>


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic) NSString *apiKey;
@property (nonatomic) NSMutableArray *photosArray;
@property (nonatomic) NSString* tags;
@end

@implementation CMJViewController


-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //viewcontroller nav bar title
    self.navigationItem.title = @"PHOTOS";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67/255.0f green:97/255.0f blue:114/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    self.apiKey = @"b540bffdef2e4be5e90462d0c2bf7cbf";
    self.photosArray = [NSMutableArray new];
    [self SearchForPhotosOnFlickr];
    
}
    
#pragma mark - HELPER METHOD - LOAD FLIKR PHOTOS

-(void)SearchForPhotosOnFlickr
{
    self.tags = @"=sanfran+surf+goldengate";
    NSString* texts = @"text=sanfran+surf+goldengate";
    
    //user the flickr photos search url to get the initial JSON data
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&%@&per_page=40&format=json&nojsoncallback=1",self.apiKey,self.tags,texts]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         NSError *error;
         
         NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
         
         [self.photosArray removeAllObjects];
         
         //get the array of dictionary items containing the photo locations
         NSArray* photos = jsonData[@"photos"][@"photo"];
         
         for (NSDictionary* item in photos)
         {
             NSString* photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",item[@"farm"],item[@"server"],item[@"id"],item[@"secret"]];
             
         
             //object conversion. Work backwards: What can I create an image from? What do I have? and how do I get to UIImage object? They key is: What do I want and how do I get back to it.
             NSLog(@"%@", photoURL);
             NSURL* url = [NSURL URLWithString:photoURL];
             NSData* data = [NSData dataWithContentsOfURL:url];
             UIImage* image = [UIImage imageWithData:data];
             
             //now I have an array with image objects
             [self.photosArray addObject:image];
             
         }
             [self.myCollectionView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         //[task resume];
     }];
    
}

#pragma mark -- delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CollectionViewCell *photoCellOne =
    [self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellID" forIndexPath:indexPath];
    
    UIImage *flickrImage = [self.photosArray objectAtIndex:indexPath.row];
    
    photoCellOne.myImageView.image = flickrImage;
    
    
    NSLog(@"make cell");
    
    return photoCellOne;
}



#pragma mark -- UISEARCHBARDELEGATE

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![searchBar.text isEqualToString:@""]) {
        [self UserSearch:searchBar.text];
        [self.searchBar endEditing:YES];
    }
}

#pragma mark - USER SEARCH FOR PHOTOS (ONCE APP IS OPEN)

-(void)UserSearch:(NSString*)text
{
    self.tags = @"=sanfran+surf+goldengate";
    NSString* texts = @"text=sanfran+surf+goldengate";
    
    //user the flickr photos search url to get the initial JSON data
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&%@&per_page=20&format=json&nojsoncallback=1",self.apiKey,self.tags,texts]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         NSError *error;
         
         NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
         
         [self.photosArray removeAllObjects];
         
         //get the array of dictionary items containing the photo locations
         NSArray* photos = jsonData[@"photos"][@"photo"];
         
         for (NSDictionary* item in photos)
         {
             NSString* photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",item[@"farm"],item[@"server"],item[@"id"],item[@"secret"]];
             
             
             //object conversion. Work backwards: What can I create an image from? What do I have? and how do I get to UIImage object? They key is: What do I want and how do I get back to it.
             NSLog(@"%@", photoURL);
             NSURL* url = [NSURL URLWithString:photoURL];
             NSData* data = [NSData dataWithContentsOfURL:url];
             UIImage* image = [UIImage imageWithData:data];
             
             //now I have an array with image objects
             [self.photosArray addObject:image];
             
         }
         [self.myCollectionView reloadData];
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         //[task resume];
     }];
    
}



////note: outlets above for each tab bar item
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    //call "search" method here based on string that's inserted
//    //[self search:@""];
//    //reference tab bar item pushed gets you the data you want to display
//    if (item.tag == 0)
//    {
//        self.tags = @"sanfran";
//        [self searchPhotos];
//    }
//    
//    else if (item.tag == 1)
//    {
//        self.tags = @"surf";
//        [self searchPhotos];
//        
//    }
//
//
//    
//}



    
    
    
    
    
    
    
    
    
    
    
@end
