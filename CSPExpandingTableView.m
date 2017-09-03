/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   06-07-2017 10:04:49
 * @Email:  dbuehre@me.com
 * @Filename: CSPExpandingTableView.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:33
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "CSPExpandingTableView.h"
#import "CSPExpandingHeaderView.h"

@interface CSPExpandingTableView () <CSPExpandingHeaderViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *sectionStatusDic;
@property (nonatomic, strong) CSPExpandingHeaderView *prevHeaderView;

@end

@implementation CSPExpandingTableView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }

    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setup];
    }

    return self;
}

- (void)setup {
    _sectionStatusDic = [[NSMutableDictionary alloc] init];
    self.initiallyExpandedSection = -1;
}

- (CSPExpandingHeaderView *)headerView {

    CSPExpandingHeaderView *headerView = [self dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];

    if (!headerView) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 32);
        headerView = [[CSPExpandingHeaderView alloc] initWithReuseIdentifier:@"Header" andFrame:frame textColor:self.headerTextColor];
        headerView.delegate = self;
    }

    return headerView;
}

- (NSArray *)indexPathsForHeaderView:(CSPExpandingHeaderView *)headerView {

    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

    for (int i = 0; i < headerView.totalRows; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:headerView.section]];
    }

    return indexPaths;
}

- (BOOL)collapsedForSection:(NSInteger)section {

    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];

    if (self.sectionStatusDic[key]) {
        return ((NSNumber *)self.sectionStatusDic[key]).boolValue;
    }

    return (self.initiallyExpandedSection == section) ? NO : self.allHeadersInitiallyCollapsed;
}

- (NSInteger)totalNumberOfRows:(NSInteger)total inSection:(NSInteger)section; {

    return ([self collapsedForSection:section]) ? 0 : total;
}

- (UIView *)headerWithTitle:(NSString *)title totalRows:(NSInteger)row inSection:(NSInteger)section {

    BOOL isCollapsed = [self collapsedForSection:section];

    CSPExpandingHeaderView *headerView = self.headerView;
    [headerView updateWithTitle:title isCollapsed:isCollapsed totalRows:row andSection:section];

    if (!self.prevHeaderView && self.initiallyExpandedSection == section) {
        self.prevHeaderView = headerView;
    }

    return headerView;
}

#pragma mark - CSPExpandingHeaderViewDelegate

- (void)didTapHeader:(CSPExpandingHeaderView *)headerView {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)headerView.section];
    BOOL isCollapsed = [self collapsedForSection:headerView.section];
    isCollapsed = !isCollapsed;

    [self.sectionStatusDic setObject:@(isCollapsed) forKey:key];

    [self beginUpdates];

    if (self.singleSelectionEnable && (self.prevHeaderView == nil || self.prevHeaderView != headerView) && ![self collapsedForSection:self.prevHeaderView.section]) {

        NSArray *indexPaths = [self indexPathsForHeaderView:self.prevHeaderView];
        [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];

        NSString *key = [NSString stringWithFormat:@"%ld", (long)self.prevHeaderView.section];
        [self.sectionStatusDic setObject:@(YES) forKey:key];

        [self.prevHeaderView updateWithTitle:self.prevHeaderView.title isCollapsed:YES totalRows:self.prevHeaderView.totalRows andSection:self.prevHeaderView.section];
    }

    NSArray *indexPaths = [self indexPathsForHeaderView:headerView];

    if (isCollapsed) {
        [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }

    [self endUpdates];

    self.prevHeaderView = headerView;
}

@end
