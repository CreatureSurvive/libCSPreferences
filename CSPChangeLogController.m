/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   29-08-2017 9:26:16
 * @Email:  dbuehre@me.com
 * @Filename: CSPChangeLogController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 01-09-2017 1:32:41
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#include "CSPChangeLogController.h"

@implementation CSPChangeLogController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.data = (NSArray *)self.specifier.properties[@"changes"] ? : @[
        @{@"Changelog Data Not Found:":@[
              @"could not find 'changes' in specifier",
          ]}
    ];

    [self makeTableView];
}

- (void)makeTableView {
    self.tableView = [[CSPExpandingTableView alloc] init];
    // self.tableView.headerTextColor = MainTint_Color;
    self.tableView.frame = self.view.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView reloadData];
    //expandableTabel information
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.allHeadersInitiallyCollapsed = YES;
    self.tableView.initiallyExpandedSection = 0;
    self.tableView.singleSelectionEnable = YES;

    [self.view addSubview:self.tableView];
}

- (NSArray *)cellsForSection:(NSInteger)section {
    NSDictionary *cells = self.data[section];
    return cells.allValues.firstObject;
}

- (NSString *)sectionTextForSection:(NSInteger)section {
    NSDictionary *cells = self.data[section];
    return cells.allKeys.firstObject;
}

 #pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cells = [self cellsForSection:section];
    return [self.tableView totalNumberOfRows:cells.count inSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self cellsForSection:indexPath.section][indexPath.row];
    if (self.tintColor) {
        cell.textLabel.textColor = self.tintColor;
    }
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

 #pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.tableView headerWithTitle:[self sectionTextForSection:section] totalRows:[self cellsForSection:section].count inSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSDebug(@"MLSChangeLogViewController didSelectRowAtIndexPath section-%ld, row-%ld", (long)indexPath.section, (long)indexPath.row);
}

@end
