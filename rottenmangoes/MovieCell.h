//
//  MovieCell.h
//  rottenmangoes
//
//  Created by William Lam on 2016-03-28.
//  Copyright © 2016 William Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieIDLabel;

@end
