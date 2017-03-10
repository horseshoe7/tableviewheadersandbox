//
//  HSStretchyHeaderTableView.m
//
//  Created by Stephen O'Connor on 23/03/16.
//  MIT License.
//

#import "HSStretchyHeaderTableView.h"

@interface HSStretchyHeaderTableView()
{
    
    CGFloat _parallaxRate;  // the ratio that the header moves in relation to the table
}
@end

@implementation HSStretchyHeaderTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // NOTE, You will have to modify this solution if you don't use InterfaceBuilder!
    
    _headerViewHeight = self.tableHeaderView.bounds.size.height;
    _parallaxRate = 0.6; // experimentally determined.  Around 0.4 - 0.6 are pretty good.
    NSLog(@"Just so you know, you're using a HSStretchyHeaderTableView on this UITableViewController!");
}

- (void)setTableHeaderView:(UIView *)tableHeaderView
{
    [super setTableHeaderView:tableHeaderView];
    _headerViewHeight = self.tableHeaderView.bounds.size.height;
    
    [self setNeedsLayout];
}

- (CGFloat)unstretchedHeaderViewHeight
{
    if (!self.tableHeaderView) {
        return 0.f;
    }
    return _headerViewHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    // only do this if there IS a header!
    if (self.tableHeaderView) {
        
        
        
        CGRect headerFrame = self.tableHeaderView.frame;
        
        if (self.hasStretchyHeader)
        {
            // this part is for stretching!  Only if you pull it past its limit will it begin to stretch
            if (self.contentOffset.y <= -self.contentInset.top) {
                //NSLog(@"Stretch");
                headerFrame.origin.y = self.contentOffset.y + self.contentInset.top;
                headerFrame.size.height = _headerViewHeight + fabs(headerFrame.origin.y);
                self.tableHeaderView.frame = headerFrame;
            }
        }
        
        // parallax and stretching shouldn't affect one another because parallax is once you start scrolling down,
        // and stretching is once you pull up at the top of a table.
        if (self.hasParallaxEffect) {
            
            
            
            // the idea here is that when contentOffset.y >= 0, the tableViewHeader will no longer be visible
            // you want to move the tableViewHeader at a slower rate than the contentOffset.y
            
            [self sendSubviewToBack:self.tableHeaderView];
            
            BOOL isNotPullingDown = self.contentOffset.y > -self.contentInset.top; // pulling down and scrolling down are opposite directions!
            BOOL isScrollingNearTopOfTable = self.contentOffset.y <= -self.contentInset.top + _headerViewHeight + 80;  // we add 80 as a hack.  It's here because you might have a section header that is transparent
            
            if (isNotPullingDown && isScrollingNearTopOfTable) {
                
                if (self.style == UITableViewStyleGrouped) {
                    NSLog(@"WARNING: THIS TABLE VIEW's Parallax Effect WAS NOT INTENDED TO WORK WITH UITableViewStyleGrouped, which is how this table view is configured!");
                }
                
                //CGFloat before = headerFrame.origin.y;  // for the NSLog statement 2 lines from now.  Uncomment as necessary
                
                headerFrame.origin.y = (self.contentOffset.y + self.contentInset.top) * _parallaxRate;
                
                //NSLog(@"CO: %i\tCI: %i\t\tHF Ob: %i\tOa:%i", (int)self.contentOffset.y, (int)self.contentInset.top, (int)before, (int)headerFrame.origin.y);
                
                self.tableHeaderView.frame = headerFrame;
            }
            else
            {
                //NSLog(@"CO: %i\tCI: %i",(int)self.contentOffset.y, (int)self.contentInset.top);
            }
        }
    }
}

@end

@implementation HSStretchyHeaderTableViewWithExpandableSectionHeader

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (self.contentOffset.y <= 0) {
        
        CGRect stretchyHeaderFrame = self.tableHeaderView.frame;
        CGRect expandableHeaderFrame = self.expandableHeaderView.frame;
        
        CGFloat adjustedY = stretchyHeaderFrame.origin.y + stretchyHeaderFrame.size.height;
        
        expandableHeaderFrame.origin.y = adjustedY;
        self.expandableHeaderView.frame = expandableHeaderFrame;
        
        adjustedY += expandableHeaderFrame.size.height;
        
        for (UITableViewCell *cell in self.visibleCells) {
            CGRect frame = cell.frame;
            frame.origin.y = adjustedY;
            cell.frame = frame;
            
            adjustedY += frame.size.height;
        }
    }
}

@end
