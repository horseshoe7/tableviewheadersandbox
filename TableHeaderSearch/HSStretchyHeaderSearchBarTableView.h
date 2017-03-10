//
//  HSStretchyHeaderSearchBarTableView.h
//  TableHeaderSearch
//
//  Created by Stephen O'Connor on 25/05/16.
//  MIT License.
//

// expects a table header to be present

#import "HSStretchyHeaderTableView.h"


@interface HSAnimatingTableHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIView *contentView;  // this has to be set in Storyboard
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *accessoryHeightConstraint;  // and this. then the table view takes care of the rest

@end


// NOTE:  This will ignore the hasParallaxEffect property of the superclass.
IB_DESIGNABLE
@interface HSStretchyHeaderSearchBarTableView : HSStretchyHeaderTableView

@property (nonatomic, weak) IBOutlet UIView *floatingContentView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *floatingHeaderHeightConstraint;

@property (nonatomic, assign) IBInspectable CGFloat closedHeightOfFloatingContentView;
@property (nonatomic, assign) IBInspectable CGFloat openHeightOfFloatingContentView;

- (void)sizeHeaderToFit;  // call on viewWillAppear:  

- (void)setFloatingContentViewOpen:(BOOL)open;


@end
