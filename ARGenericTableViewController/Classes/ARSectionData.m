/*
 * ARSectionData.m
 *
 * Copyright (c) 2013 arconsis IT-Solutions GmbH
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#import "ARSectionData.h"

@interface ARSectionData ()
@property (nonatomic, strong) NSMutableArray *mutableCellDataArray;
@end

@implementation ARSectionData

- (id)initWithCellDataArray:(NSArray *)cellDataArray
{
    self = [super init];
    if (self) {
        self.mutableCellDataArray = [[NSMutableArray alloc] init];
        if (cellDataArray) {
            [self.mutableCellDataArray addObjectsFromArray:cellDataArray];
        }
        self.headerHeight = 0;
        self.footerHeight = 0;
    }
    return self;
}

- (id)init
{
    return [self initWithCellDataArray:nil];
}

- (NSString *)headerTitle
{
    if (_headerTitle && _headerTitle.length > 0 && !self.headerView) {
        return _headerTitle;
    } else {
        return @"";
    }
}

- (CGFloat)headerHeight
{
    if (_headerHeight <= 0 && self.headerView) {
        return self.headerView.frame.size.height;
    } else if (_headerHeight <= 0 && _headerTitle){
        return 30;
    } else {
        return _headerHeight;
    }
}

- (NSString *)footerTitle
{
    if (_footerTitle && _footerTitle.length > 0 && !self.headerView) {
        return _footerTitle;
    } else {
        return @"";
    }
}

- (CGFloat)footerHeight
{
    if (_footerHeight <= 0 && self.footerView) {
        return self.footerView.frame.size.height;
    } else if (_footerHeight <= 0 && _footerTitle){
        return 30;
    } else {
        return _footerHeight;
    }
}

- (ARCellData *)cellDataAtIndex:(NSUInteger)index
{
    if (index < self.cellCount) {
        return [self.mutableCellDataArray objectAtIndex:index];
    } else {
        return nil;
    }
}

- (BOOL)replaceCellDataAtIndex:(NSUInteger)index withCellData:(ARCellData *)cellData
{
    if (index <= self.cellCount) {
        [self.mutableCellDataArray replaceObjectAtIndex:index withObject:cellData];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)insertCellData:(ARCellData *)cellData atIndex:(NSUInteger)index
{
    if (!cellData) {
        return NO;
    }
    
    if (index <= self.cellCount) {
        [self.mutableCellDataArray insertObject:cellData atIndex:index];
        return YES;
    } else {
        return [self addCellData:cellData];
    }
}

- (BOOL)addCellData:(ARCellData *)cellData
{
    if (!cellData) {
        return NO;
    }
    
    [self.mutableCellDataArray addObject:cellData];
    return YES;
}

- (BOOL)addCellDataFromArray:(NSArray *)cellDataArray
{
    if (!cellDataArray) {
        return NO;
    }
    [self.mutableCellDataArray addObjectsFromArray:cellDataArray];
    return YES;
}

- (BOOL)moveCellDataFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex < self.cellCount && toIndex <= self.cellCount) {
        ARCellData *cellData = [self.mutableCellDataArray objectAtIndex:fromIndex];

        BOOL result = YES;
        result &= [self removeCellDataAtIndex:fromIndex];
        result &= [self insertCellData:cellData atIndex:toIndex];
        return result;
    }
    return NO;
}

- (BOOL)removeCellDataAtIndex:(NSUInteger)index
{
    if (index < self.cellCount) {
        [self.mutableCellDataArray removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

- (void)removeAllCellData
{
    [self.mutableCellDataArray removeAllObjects];
}

- (NSArray *)cellDataArray
{
    return [NSArray arrayWithArray:self.mutableCellDataArray];
}

- (NSUInteger)cellCount
{
    return [self.mutableCellDataArray count];
}

@end
