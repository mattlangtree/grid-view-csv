//
//  TableCell.m
//  GridViewCSV
//
//  Created by Matt Langtree on 9/05/13.
//  Copyright (c) 2013 Matt Langtree. All rights reserved.
//

#import "TableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TableCell

+ (NSString*) reuseIdentifier
{
    return @"TableCell";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor lightTextColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.selectedBackgroundView setBackgroundColor:[UIColor blueColor]];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setIsOddLine:(BOOL)isOddLine
{
    _isOddLine = isOddLine;
    
    if (isOddLine) {
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        self.label.textColor = [UIColor darkGrayColor];
    }
    else {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.label.textColor = [UIColor darkGrayColor];
    }
}

- (void)setValue:(id)value
{
    _value = value;
    if ([value isKindOfClass:[NSString class]]) {
        [self.label setText:(NSString *)value];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        [self.label setText:[(NSNumber *) value stringValue]];
        [self.label setTextAlignment:NSTextAlignmentRight];
    }
    else if ([value isKindOfClass:[NSNull class]]) {
        [self.label setText:@"NULL"];
        [self.label setTextColor:[UIColor lightGrayColor]];
    }
    else {
        [self.label setText:@" "];
    }
}

@end
