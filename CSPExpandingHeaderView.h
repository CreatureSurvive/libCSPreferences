/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   02-07-2017 5:12:52
 * @Email:  dbuehre@me.com
 * @Filename: CSPExpandingHeaderView.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:23
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


@class CSPExpandingHeaderView;

@protocol CSPExpandingHeaderViewDelegate <NSObject>

- (void)didTapHeader:(CSPExpandingHeaderView *)view;

@end

@interface CSPExpandingHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) id<CSPExpandingHeaderViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger section;
@property (nonatomic, readonly) NSInteger totalRows;
@property (nonatomic, strong, readonly) NSString *title;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame textColor:(UIColor *)color;
- (void)updateWithTitle:(NSString *)title isCollapsed:(BOOL)isCollapsed totalRows:(NSInteger)row andSection:(NSInteger)section;

@end
