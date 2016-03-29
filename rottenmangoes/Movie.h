//
//  Movie.h
//  rottenmangoes
//
//  Created by William Lam on 2016-03-28.
//  Copyright © 2016 William Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *movieDescription;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *movieID;

@end
