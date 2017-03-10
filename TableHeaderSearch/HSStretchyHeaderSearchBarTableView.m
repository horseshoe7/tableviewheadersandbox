//
//  HSStretchyHeaderSearchBarTableView.m
//  TableHeaderSearch
//
//  Created by Stephen O'Connor on 25/05/16.
//  MIT License.
//

#import "HSStretchyHeaderSearchBarTableView.h"



@implementation HSAnimatingTableHeaderView

- (CGSize)intrinsicContentSize
{
    CGSize size = [self.contentView intrinsicContentSize];
    size.height += self.accessoryHeightConstraint.constant;
    
    return size;
}

@end



@interface HSStretchyHeaderSearchBarTableView()
{
    NSInteger _numUpdateRequests;
    BOOL _isOpen;
}
@property (nonatomic, assign) BOOL animatingOpen;
@property (nonatomic, assign) BOOL animatingClose;
@end

@implementation HSStretchyHeaderSearchBarTableView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.hasParallaxEffect) {
        NSLog(@"Can't get this to work with parallax.  Setting to OFF");
        self.parallaxEffect = NO;
    }
    
    //_originalWidth = self.bounds.size.width;

    if (self.floatingContentView && self.floatingContentView.superview != self) {
        
        UIView *floatingView = self.floatingContentView;
        
        [self.floatingContentView removeFromSuperview];
        
        [self addSubview:floatingView];
        
    }
    
    if (self.tableHeaderView) {
        NSAssert([self.tableHeaderView isKindOfClass:[HSAnimatingTableHeaderView class]], @"Designed to work with a HSAnimatingTableHeaderView object!");
    }
    else
    {
        NSLog(@"Expected a table header view for this to work!");
    }
}

- (void)sizeHeaderToFit
{
    UIView *headerView = self.tableHeaderView;
    
    CGFloat height;
    
    if ([headerView isKindOfClass:[HSAnimatingTableHeaderView class]]) {
        
        HSAnimatingTableHeaderView *animatingHeader = (HSAnimatingTableHeaderView*)headerView;
        
        height = [animatingHeader intrinsicContentSize].height;
    }
    else
    {
        [headerView setNeedsLayout];
        [headerView layoutIfNeeded];
        height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    
    
    
    headerView.frame = ({
        CGRect headerFrame = headerView.frame;
        headerFrame.size.height = height;
        headerFrame;
    });
    
    self.tableHeaderView = headerView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"Constraints: \n%@", self.tableHeaderView.constraints);
    
    NSLog(@"layoutSubviews: contentOffsetY: %i", (int)self.contentOffset.y);
    
    [self bringSubviewToFront:self.floatingContentView];
    [self sendSubviewToBack:self.tableHeaderView];
    
    CGRect frame = self.floatingContentView.frame;
    
    if (self.animatingOpen) {
        frame.size.height = self.openHeightOfFloatingContentView;
    }
    else if (self.animatingClose)
    {
        frame.size.height = self.closedHeightOfFloatingContentView;
    }
    else
    {
        // initial state
        frame.size.height = self.closedHeightOfFloatingContentView;
    }
    
    CGRect headerFrame = self.tableHeaderView.frame;
    
    // couldn't get it working with parallax.  Maybe in the future... hence the NO && ....
    if (/* DISABLES CODE */ (NO) &&
        self.hasParallaxEffect && self.contentOffset.y > 0) {
        
        NSArray *indexpaths = [self indexPathsForVisibleRows];
        if (indexpaths.count > 0 && [indexpaths[0] row] == 0) {
            
            UITableViewCell *cell = [self cellForRowAtIndexPath:indexpaths[0]];
            
            CGRect cellFrame = cell.frame;
            
            frame.origin.y = cellFrame.origin.y - frame.size.height;
            
            frame.origin.y = MAX(cellFrame.origin.y - frame.size.height, self.contentOffset.y);
            
        }
        else
        {
            frame.origin.y = MAX(headerFrame.origin.y + headerFrame.size.height - frame.size.height, self.contentOffset.y);
        }
        
    }
    else
    {
        frame.origin.y = MAX(headerFrame.origin.y + headerFrame.size.height - frame.size.height, self.contentOffset.y);
    }
    
    
    frame.size.width = self.bounds.size.width;
    
    self.floatingContentView.frame = frame;
}

// because our header stuff uses begin/end updates but also could be triggered by a NSFetchedResultsControllerDelegate, we keep track of who's asking for updates
- (void)beginUpdates
{
    _numUpdateRequests++;
    if (_numUpdateRequests == 1) {
        [super beginUpdates];
    }
}

- (void)endUpdates
{
    _numUpdateRequests--;
    if (_numUpdateRequests == 0) {
        [super endUpdates];
    }
}

- (void)setFloatingContentViewOpen:(BOOL)open
{
    CGFloat height = self.tableHeaderView.bounds.size.height;
    HSAnimatingTableHeaderView *animatingHeader = (HSAnimatingTableHeaderView*)self.tableHeaderView;
    
    if (open)
    {
        height = [animatingHeader.contentView intrinsicContentSize].height + self.openHeightOfFloatingContentView;
    }
    else
    {
        height = [animatingHeader.contentView intrinsicContentSize].height + self.closedHeightOfFloatingContentView;
    }
    
    [self _animateToHeaderHeight:height open:open];
}

- (void)_animateToHeaderHeight:(CGFloat)headerHeight open:(BOOL)open
{
    
    self.animatingClose = !open;
    self.animatingOpen = open;
    
    UIView *headerView = self.tableHeaderView;
    CGRect frame = headerView.frame;
    frame.size.height = headerHeight;
    
    [self beginUpdates];
    
    HSAnimatingTableHeaderView *animatingHeader = (HSAnimatingTableHeaderView*)headerView;
    
    animatingHeader.accessoryHeightConstraint.constant = open ? self.openHeightOfFloatingContentView : self.closedHeightOfFloatingContentView;
    
    headerView.frame = frame;
    
    self.tableHeaderView = headerView;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self layoutIfNeeded];
                     }];
    
    
    [self endUpdates];
    
}


@end
