/*
 * ARGenericTableViewController.h
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

@interface ARGenericTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ARTableViewDataDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

// the tableView automatically reloads if you set this property
@property (nonatomic, strong) ARTableViewData *tableViewData;

// set to YES and use the methods from the ARTableViewData class to animate changes
@property (nonatomic) BOOL animateChanges;

- (id)initWithStyle:(UITableViewStyle)style;

// use this method to register Classes of the used TableViewCell (Sub)classes. This works also with iOS 5 
- (void)registerClass:(Class)Class forCellReuseIdentifier:(NSString *)identifier;

// override this method to use a custom tableview class
- (Class)classForTableView;

@end
