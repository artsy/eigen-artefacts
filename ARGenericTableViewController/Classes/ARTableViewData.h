/*
 * ARTableViewData.h
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
#import "ARCellData.h"

typedef enum TableViewDataChangeType {
	TableViewDataChangeInsert,
	TableViewDataChangeDelete,
	TableViewDataChangeMove,
	TableViewDataChangeUpdate
} TableViewDataChangeType;

@class ARTableViewData;
@protocol ARTableViewDataDelegate <NSObject>

- (void)tableViewDataWillChange:(ARTableViewData *)tableViewData;

- (void)tableViewData:(ARTableViewData *)tableViewData didChangeSectionAtIndex:(NSUInteger)sectionIndex
        forChangeType:(TableViewDataChangeType)type
      newSectionIndex:(NSUInteger)newSectionIndex;

- (void)tableViewData:(ARTableViewData *)tableViewData didChangeRowAtIndexPath:(NSIndexPath *)indexPath
        forChangeType:(TableViewDataChangeType)type
         newIndexPath:(NSIndexPath *)newIndexPath;

- (void)tableViewDataDidChange:(ARTableViewData *)tableViewData;

@end

@interface ARTableViewData : NSObject

@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic, strong, readonly) NSArray *allSections;
@property (nonatomic, weak) id<ARTableViewDataDelegate> delegate;

- (id)initWithSectionDataArray:(NSArray *)sectionDataArray;

- (NSIndexPath *)indexPathForCellData:(ARCellData *)cellData;
- (ARSectionData *)sectionDataForSection:(NSInteger)section;
- (ARCellData *)cellDataAtIndexPath:(NSIndexPath *)indexPath;


// changes with the following methods will call the ARTableViewDataDelegate methods
// cell manipulation
- (BOOL)replaceCellDataAtIndexPath:(NSIndexPath *)indexPath withCellData:(ARCellData *)cellData;
- (BOOL)removeCellDataAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)moveCellDataFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (BOOL)insertCellData:(ARCellData *)cellData atIndexPath:(NSIndexPath *)indexPath;

// section manipulation
- (BOOL)addSectionData:(ARSectionData *)sectionData;
- (BOOL)addSectionDataFromArray:(NSArray *)sectionDataArray;
- (BOOL)insertSectionData:(ARSectionData *)sectionData atIndex:(NSUInteger)index;
- (BOOL)replaceSectionDataAtIndex:(NSUInteger)index withSectionData:(ARSectionData *)cellData;
- (BOOL)moveSectionDataFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL)removeSectionDataAtIndex:(NSUInteger)index;
- (void)removeAllSectionData;

@end
