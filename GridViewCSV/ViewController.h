//
//  ViewController.h
//  GridViewCSV
//
//  Created by Matt Langtree on 8/05/13.
//  Copyright (c) 2013 Matt Langtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView *gridView;

@end
