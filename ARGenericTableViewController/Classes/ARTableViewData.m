/*
 * ARTableViewData.m
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

#import "ARTableViewData.h"

@interface ARTableViewData ()
@property (nonatomic, strong) NSMutableArray *mutableSectionDataArray;
@end

@implementation ARTableViewData

- (id)init
{
    self = [super init];
    if (self) {
        self.mutableSectionDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithSectionDataArray:(NSArray *)sectionDataArray
{
    self = [self init];
    if (self) {
        [self addSectionDataFromArray:sectionDataArray];
    }
    return self;
}

- (NSIndexPath *)indexPathForCellData:(ARCellData *)cellData
{
    NSIndexPath *indexPath;
    NSInteger section = 0;
    for (ARSectionData *sectionData in self.mutableSectionDataArray) {
        NSUInteger row = [sectionData.cellDataArray indexOfObject:cellData];
        if (row != NSNotFound) {
            indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            break;
        }
        section++;
    }
    return indexPath;
}

- (ARCellData *)cellDataAtIndexPath:(NSIndexPath *)indexPath
{
    ARCellData *cellData = nil;
    if (indexPath.section < self.mutableSectionDataArray.count) {
        ARSectionData *sectionData = self.mutableSectionDataArray[indexPath.section];
        
        if (indexPath.row < sectionData.cellCount) {
            cellData = [sectionData cellDataAtIndex:indexPath.row];
        }
    }
    return cellData;
}

- (BOOL)replaceCellDataAtIndexPath:(NSIndexPath *)indexPath withCellData:(ARCellData *)cellData
{
    BOOL couldReplace = NO;
    if (indexPath.section < self.mutableSectionDataArray.count) {
        ARSectionData *sectionData = self.mutableSectionDataArray[indexPath.section];
        couldReplace = [sectionData replaceCellDataAtIndex:indexPath.row withCellData:cellData];

    }
    
    if (couldReplace) {
        [self startChange];
        [self didChangeRowAtIndexPath:indexPath changeType:TableViewDataChangeUpdate newIndexPath:indexPath];
        [self endChange];
    }
    return couldReplace;
}

- (BOOL)removeCellDataAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL couldRemove = NO;
    ARSectionData *sectionData = [self sectionDataForSection:indexPath.section];

    if (sectionData.cellCount == 1) {
        couldRemove = [self removeSectionDataAtIndex:indexPath.section];
    } else {
        couldRemove = [sectionData removeCellDataAtIndex:indexPath.row];
        if (couldRemove) {
            [self startChange];
            [self didChangeRowAtIndexPath:indexPath changeType:TableViewDataChangeDelete newIndexPath:nil];
            [self endChange];
        }
    }
    return couldRemove;
}

- (BOOL)moveCellDataFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    BOOL couldMove = NO;
    ARSectionData *sectionData = [self sectionDataForSection:fromIndexPath.section];
    if (fromIndexPath.section == toIndexPath.section) {
        couldMove = [sectionData moveCellDataFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
        if (couldMove) {
            [self startChange];
            [self didChangeRowAtIndexPath:fromIndexPath changeType:TableViewDataChangeMove newIndexPath:toIndexPath];
            [self endChange];
        }
    } else {
        ARCellData *cellData = [self cellDataAtIndexPath:fromIndexPath];
        ARSectionData *toSection = [self sectionDataForSection:toIndexPath.section];

        couldMove = [toSection insertCellData:cellData atIndex:toIndexPath.row];
        couldMove = [sectionData removeCellDataAtIndex:fromIndexPath.row];
    }

    return couldMove;
}

- (BOOL)insertCellData:(ARCellData *)cellData atIndexPath:(NSIndexPath *)indexPath
{
    BOOL couldInsert = NO;

    ARSectionData *sectionData = [self sectionDataForSection:indexPath.section];
    couldInsert = [sectionData insertCellData:cellData atIndex:indexPath.row];

    if (couldInsert) {
        [self startChange];
        [self didChangeRowAtIndexPath:indexPath changeType:TableViewDataChangeInsert newIndexPath:indexPath];
        [self endChange];
    }
    return couldInsert;
}

- (ARSectionData *)sectionDataForSection:(NSInteger)section
{
    ARSectionData *sectionData = nil;
    if (section <= self.mutableSectionDataArray.count) {
        sectionData = self.mutableSectionDataArray[section];
    }
    
    return sectionData;
}

- (BOOL)insertSectionData:(ARSectionData *)sectionData atIndex:(NSUInteger)index
{
    BOOL couldInsert = NO;
    if (sectionData) {
        if (index <= self.mutableSectionDataArray.count) {
            [self.mutableSectionDataArray insertObject:sectionData atIndex:index];
            couldInsert = YES;
        } else {
            couldInsert = [self addSectionData:sectionData];
            index = self.numberOfSections;
        }
    }

    if (couldInsert) {
        [self startChange];
        [self didChangeSectionAtIndex:index changeType:TableViewDataChangeInsert newIndex:index];
        [self endChange];
    }
    return couldInsert;
}

- (BOOL)replaceSectionDataAtIndex:(NSUInteger)index withSectionData:(ARSectionData *)sectionData
{
    BOOL couldReplace = NO;
    if (sectionData) {
        if (index < self.numberOfSections) {
            [self.mutableSectionDataArray replaceObjectAtIndex:index withObject:sectionData];
            couldReplace = YES;
        }
    }

    if (couldReplace) {
        [self startChange];
        [self didChangeSectionAtIndex:index changeType:TableViewDataChangeUpdate newIndex:index];
        [self endChange];
    }
    return couldReplace;
}

- (BOOL)addSectionData:(ARSectionData *)sectionData
{
    BOOL couldAdd = NO;
    if (sectionData) {
        [self.mutableSectionDataArray addObject:sectionData];
        couldAdd = YES;
    }

    if (couldAdd) {
        [self startChange];
        [self didChangeSectionAtIndex:self.numberOfSections - 1 changeType:TableViewDataChangeInsert newIndex:self.numberOfSections - 1];
        [self endChange];
    }
    return couldAdd;
}

- (BOOL)addSectionDataFromArray:(NSArray *)sectionDataArray
{
    BOOL couldAdd = NO;
    if (sectionDataArray) {
        [self.mutableSectionDataArray addObjectsFromArray:sectionDataArray];
        couldAdd = YES;
    }

    if (couldAdd) {
        [self startChange];
        for (int i = self.numberOfSections - sectionDataArray.count; i < self.numberOfSections; i++) {
            [self didChangeSectionAtIndex:i changeType:TableViewDataChangeInsert newIndex:i];
        }
        [self endChange];
    }
    return couldAdd;
}

- (BOOL)moveSectionDataFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    BOOL couldMove = NO;
    if (fromIndex < self.mutableSectionDataArray.count && toIndex <= self.mutableSectionDataArray.count) {
        ARSectionData *sectionData = [self sectionDataForSection:fromIndex];
        couldMove = YES;
        couldMove = couldMove || [self removeSectionDataAtIndex:fromIndex];
        couldMove = couldMove || [self insertSectionData:sectionData atIndex:toIndex];
    }

    if (couldMove) {
        [self startChange];
        [self didChangeSectionAtIndex:fromIndex changeType:TableViewDataChangeMove newIndex:toIndex];
        [self endChange];
    }

    return couldMove;
}

- (BOOL)removeSectionDataAtIndex:(NSUInteger)index
{
    BOOL couldRemove = NO;
    if (index < self.mutableSectionDataArray.count) {
        [self.mutableSectionDataArray removeObjectAtIndex:index];
        couldRemove = YES;
    }

    if (couldRemove) {
        [self startChange];
        [self didChangeSectionAtIndex:index changeType:TableViewDataChangeDelete newIndex:-1];
        [self endChange];
    }

    return couldRemove;
}

- (void)removeAllSectionData
{
    int numberOfSections = self.numberOfSections;
    [self.mutableSectionDataArray removeAllObjects];

    [self startChange];
    for (int i = numberOfSections - 1; i >= 0; i--) {
        [self didChangeSectionAtIndex:i changeType:TableViewDataChangeDelete newIndex:-1];
    }
    [self endChange];
}

- (NSInteger)numberOfSections
{
    return self.mutableSectionDataArray.count;
}

- (NSArray *)allSections
{
    return [self.mutableSectionDataArray copy];
}

- (void)startChange
{
    if ([self.delegate respondsToSelector:@selector(tableViewDataWillChange:)]) {
        [self.delegate tableViewDataWillChange:self];
    }
}

- (void)didChangeSectionAtIndex:(NSUInteger)index changeType:(TableViewDataChangeType)changeType newIndex:(NSUInteger)newIndex
{
    if ([self.delegate respondsToSelector:@selector(tableViewData:didChangeSectionAtIndex:forChangeType:newSectionIndex:)]) {
        [self.delegate tableViewData:self didChangeSectionAtIndex:index forChangeType:changeType newSectionIndex:newIndex];
    }
}

- (void)didChangeRowAtIndexPath:(NSIndexPath *)indexPath changeType:(TableViewDataChangeType)changeType newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([self.delegate respondsToSelector:@selector(tableViewData:didChangeRowAtIndexPath:forChangeType:newIndexPath:)]) {
        [self.delegate tableViewData:self didChangeRowAtIndexPath:indexPath forChangeType:changeType newIndexPath:newIndexPath];
    }
}

- (void)endChange
{
    if ([self.delegate respondsToSelector:@selector(tableViewDataDidChange:)]) {
        [self.delegate tableViewDataDidChange:self];
    }
}
@end
