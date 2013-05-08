//
//  ViewController.m
//  GridViewCSV
//
//  Created by Matt Langtree on 8/05/13.
//  Copyright (c) 2013 Matt Langtree. All rights reserved.
//

#import "ViewController.h"

float leftPadding = 4.f;
float rightPadding = 4.f;

static UIColor *rowOddColour;

@interface ViewController ()
{
    NSArray *itemsArray;
}

@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        if (!rowOddColour) {
            rowOddColour = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

            CGSize contentSize = [self contentSize];
            _gridView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
            [_gridView setBackgroundColor:[UIColor whiteColor]];
            [_scrollView addSubview:_gridView];
            [self reloadData];
            [_scrollView setNeedsDisplay];
            
        });
    });
    
    [_scrollView setAlwaysBounceHorizontal:YES];
    [_scrollView setAlwaysBounceVertical:YES];
}

- (CGSize)contentSize
{
    return CGSizeMake(([self columnsInTable] +1) * [self widthForColumn], ([self rowsInTable] + 1) * [self heightForRow]);
}

- (void)reloadData
{
    [_scrollView setContentSize:[self contentSize]];
    
    for (int r = 0; r < [self rowsInTable] + 1; r++) {
        int rowindex = (r > 0) ? r - 1 : 0;
        NSDictionary *dictionary = [itemsArray objectAtIndex:rowindex];
        NSArray *dictionaryKeys = [dictionary allKeys];
        for (int c=0; c < [self columnsInTable] + 1; c++) {
            int columnindex = (c > 0) ? c - 1 : 0;
            UILabel *textLabel = [[UILabel alloc] init];
            [textLabel setFont:[UIFont systemFontOfSize:13.f]];
            if (r == 0) {
                [textLabel setText:[dictionaryKeys objectAtIndex:columnindex]];
                [textLabel setFont:[UIFont boldSystemFontOfSize:13.f]];
                [textLabel setBackgroundColor:[UIColor lightGrayColor]];
                [textLabel setFrame:CGRectMake((c * [self widthForColumn]), r * [self heightForRow], [self widthForColumn], [self heightForRow])];
            }
            else if (c == 0) {
                [textLabel setText:[NSString stringWithFormat:@"%d",r]];
                [textLabel setFont:[UIFont boldSystemFontOfSize:13.f]];
                [textLabel setBackgroundColor:[UIColor lightGrayColor]];
                [textLabel setFrame:CGRectMake((c * [self widthForColumn]), r * [self heightForRow], [self widthForColumn], [self heightForRow])];
            }
            
            else {
                [textLabel setFrame:CGRectMake((c * [self widthForColumn])+leftPadding, r * [self heightForRow], [self widthForColumn] - leftPadding - rightPadding, [self heightForRow])];
                id value = [dictionary objectForKey:[dictionaryKeys objectAtIndex:columnindex]];
                if ([value isKindOfClass:[NSString class]]) {
                    [textLabel setText:(NSString *)value];
                }
                else if ([value isKindOfClass:[NSNumber class]]) {
                    [textLabel setText:[(NSNumber *) value stringValue]];
                    [textLabel setTextAlignment:NSTextAlignmentRight];
                }
                else if ([value isKindOfClass:[NSNull class]]) {
                    [textLabel setText:@"NULL"];
                    [textLabel setTextColor:[UIColor lightGrayColor]];
                }
                else {
                    [textLabel setText:@" "];
                }
                if (r % 2 == 0) {
                    [textLabel setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
                }
                else {
                    [textLabel setBackgroundColor:[UIColor whiteColor]];
                }
            }
            [_gridView addSubview:textLabel];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (int)columnsInTable
{
    return 8;
}

- (int)rowsInTable
{
    return itemsArray.count;
}

- (float)widthForColumn
{
    return 160.f;
}

- (float)heightForRow
{
    return 30.f;
}

@end
