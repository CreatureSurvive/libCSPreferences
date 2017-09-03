/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   02-07-2017 5:12:52
 * @Email:  dbuehre@me.com
 * @Filename: CSPExpandingTableView.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:30
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


@interface CSPExpandingTableView : UITableView

@property (nonatomic, assign) BOOL allHeadersInitiallyCollapsed;
@property (nonatomic, assign) int initiallyExpandedSection;
@property (nonatomic, assign) BOOL singleSelectionEnable;
@property (nonatomic, retain) UIColor *headerTextColor;

- (NSInteger)totalNumberOfRows:(NSInteger)total inSection:(NSInteger)section;
- (UIView *)headerWithTitle:(NSString *)title totalRows:(NSInteger)row inSection:(NSInteger)section;

@end
