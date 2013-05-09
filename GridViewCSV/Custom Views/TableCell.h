//
//  TableCell.h
//  GridViewCSV
//
//  Created by Matt Langtree on 9/05/13.
//  Copyright (c) 2013 Matt Langtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UICollectionViewCell

+ (NSString*) reuseIdentifier;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic) BOOL isOddLine;

@property (nonatomic, strong) id value;

@end
