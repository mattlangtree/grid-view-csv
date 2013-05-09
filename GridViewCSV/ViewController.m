//
//  ViewController.m
//  GridViewCSV
//
//  Created by Matt Langtree on 8/05/13.
//  Copyright (c) 2013 Matt Langtree. All rights reserved.
//

#import "ViewController.h"
#import "TableLayout.h"
#import "TableCell.h"

@interface ViewController ()
{
    NSArray *itemsArray;
    BOOL    _alertVisible;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize collection view and layout object
    TableLayout *layout = [[TableLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_collectionView];
    [self.collectionView registerClass:[TableCell class] forCellWithReuseIdentifier:[TableCell reuseIdentifier]];
        
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self updateData];
    
}

- (void)updateData
{
    
    if (!itemsArray) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            
            NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"json"];
            NSString *jsonString = [NSString stringWithContentsOfFile:jsonFilePath encoding:NSUTF8StringEncoding error:NULL];

            NSError *e = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
            
            if (!jsonArray) {
                NSLog(@"Error parsing JSON: %@", e);
            } else {
                for(NSDictionary *item in jsonArray) {
                    NSLog(@"Item: %@", item);
                }
            }
            
            NSLog(@"jsonArray: %@",jsonArray);
            itemsArray = jsonArray;
            dispatch_async(dispatch_get_main_queue(), ^{

                [_collectionView reloadData];
                
            });
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (itemsArray) ? itemsArray.count : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (itemsArray) ? [[itemsArray objectAtIndex:0] count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TableCell reuseIdentifier] forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"(%d,%d)", indexPath.item, indexPath.section];
    cell.isOddLine = (indexPath.section %2) == 1;
    
    NSDictionary *dictionary = [itemsArray objectAtIndex:indexPath.section];
    NSArray *dictionaryKeys = [dictionary allKeys];
    id value = [dictionary objectForKey:[dictionaryKeys objectAtIndex:indexPath.item]];
    
    [cell setValue:value];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell selected: %d, %d",indexPath.section,indexPath.item);
}

@end
