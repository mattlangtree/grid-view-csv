//
//  TableLayout.m
//  GridViewCSV
//
//  Created by Matt Langtree on 9/05/13.
//  Copyright (c) 2013 Matt Langtree. All rights reserved.
//

#import "TableLayout.h"

#define ITEM_WIDTH 160
#define ITEM_HEIGHT 55

@interface TableLayout()

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numCols;

@end

@implementation TableLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.numRows = [self.collectionView numberOfSections];
    self.numCols = [self.collectionView numberOfItemsInSection:0];  // assume same for all rows for now
    self.contentSize = CGSizeMake(self.numCols * ITEM_WIDTH, self.numRows * ITEM_HEIGHT);
}

-(CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.frame = CGRectMake(path.item * ITEM_WIDTH, path.section * ITEM_HEIGHT, ITEM_WIDTH, ITEM_HEIGHT);
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    
    NSUInteger startRow = floorf(rect.origin.y / ITEM_HEIGHT);
    NSUInteger endRow = MIN(self.numRows -1, ceilf(CGRectGetMaxY(rect) / ITEM_HEIGHT));
    NSUInteger startCol = floorf(rect.origin.x / ITEM_WIDTH);
    NSUInteger endCol = MIN(self.numCols -1, ceilf(CGRectGetMaxX(rect) / ITEM_WIDTH));
    for (NSUInteger r = startRow; r <= endRow; r++)
    {
        for (NSUInteger c = startCol; c <=  endCol; c++)
        {
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:c inSection:r]]];
        }
    }
    
    return attributes;
}
@end