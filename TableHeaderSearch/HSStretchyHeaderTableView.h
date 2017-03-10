//
//  HSStretchyHeaderTableView.h
//
//  Created by Stephen O'Connor on 23/03/16.
//  MIT License.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HSStretchyHeaderTableView : UITableView
{
    @protected
    CGFloat _headerViewHeight;
}
@property (nonatomic, readonly) CGFloat unstretchedHeaderViewHeight;
@property (nonatomic, assign, getter=hasStretchyHeader) IBInspectable BOOL stretchyHeader;
@property (nonatomic, assign, getter=hasParallaxEffect) IBInspectable BOOL parallaxEffect;

@end


@interface HSStretchyHeaderTableViewWithExpandableSectionHeader : HSStretchyHeaderTableView

@property (nonatomic, weak) IBOutlet UIView *expandableHeaderView;

@end
