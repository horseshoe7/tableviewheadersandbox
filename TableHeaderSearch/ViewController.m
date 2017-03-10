//
//  ViewController.m
//  TableHeaderSearch
//
//  Created by Stephen O'Connor on 25/05/16.
//  MIT License.
//

#import "ViewController.h"
#import "HSStretchyHeaderSearchBarTableView.h"


@interface ViewController ()

@end

static CGFloat kHeaderClosedHeight = 257.f;
static CGFloat kHeaderOpenHeight = 301.f;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    HSStretchyHeaderSearchBarTableView *tv = (HSStretchyHeaderSearchBarTableView*)self.tableView;
//    
//    tv.closedHeightOfFloatingContentView = 44;
//    tv.openHeightOfFloatingContentView = 88;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.tableView isKindOfClass:[HSStretchyHeaderSearchBarTableView class]]) {
        [(HSStretchyHeaderSearchBarTableView*)self.tableView sizeHeaderToFit];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)open:(id)sender
{
    HSStretchyHeaderSearchBarTableView *tv = (HSStretchyHeaderSearchBarTableView*)self.tableView;
    
    [tv setFloatingContentViewOpen:YES];
    
}

- (IBAction)close:(id)sender
{
    HSStretchyHeaderSearchBarTableView *tv = (HSStretchyHeaderSearchBarTableView*)self.tableView;
    [tv setFloatingContentViewOpen:NO];

}

@end
