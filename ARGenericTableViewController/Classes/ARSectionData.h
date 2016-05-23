/*
 * ARSectionData.h
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

#import "ARCellData.h"

@interface ARSectionData : NSObject

// header
@property (nonatomic, strong)   NSString *headerTitle;
@property (nonatomic, strong)   UIView *headerView;
@property (nonatomic)           CGFloat headerHeight; // if the headerView is set its height is used

// footer
@property (nonatomic, strong)   NSString *footerTitle;
@property (nonatomic, strong)   UIView *footerView;
@property (nonatomic)           CGFloat footerHeight; // if the footerView is set its height is used

// cells
@property (nonatomic, strong, readonly)   NSArray *cellDataArray;
@property (nonatomic, readonly)           NSUInteger cellCount;

/// optionally support a reusable identifiers for header views
@property (nonatomic, strong) NSString *headerIdentifier;
@property (nonatomic, strong) NSString *footerIdentifier;

- (id)initWithCellDataArray:(NSArray *)cellDataArray;
- (ARCellData *)cellDataAtIndex:(NSUInteger)index;

- (BOOL)addCellData:(ARCellData *)cellData;
- (BOOL)addCellDataFromArray:(NSArray *)cellDataArray;
- (BOOL)replaceCellDataAtIndex:(NSUInteger)index withCellData:(ARCellData *)cellData ;
- (BOOL)insertCellData:(ARCellData *)cellData atIndex:(NSUInteger)index;
- (BOOL)moveCellDataFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL)removeCellDataAtIndex:(NSUInteger)index;
- (void)removeAllCellData;


@end
