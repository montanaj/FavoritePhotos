//
//  CollectionViewCell.h
//  FavoritePhotos
//
//  Created by Claire Jencks on 3/31/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell


//whatever happens to the cell happens to the image because the image is now an inherent property of the cell class
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@end
