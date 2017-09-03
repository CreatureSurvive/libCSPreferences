/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   29-08-2017 9:23:08
 * @Email:  dbuehre@me.com
 * @Filename: CSPChangeLogController.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 29-08-2017 11:30:15
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#include <Preferences/PSViewController.h>
#include <Preferences/PSSpecifier.h>
#include "CSPExpandingTableView.h"

@interface CSPChangeLogController : PSViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) CSPExpandingTableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end
