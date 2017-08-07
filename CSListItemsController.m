/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   01-07-2017 5:43:54
 * @Email:  dbuehre@me.com
 * @Project: motuumLS
 * @Filename: CSListItemsController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 08-07-2017 5:38:42
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#import "CSListItemsController.h"

@implementation CSListItemsController

// set the tint colors before the view appears
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTint];
}

// sets the tint colors for the view
- (void)setTint {
    // Color the navbar
    self.navigationController.navigationController.navigationBar.tintColor = _accentTintColor;
    self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : _accentTintColor};

    // set tableView tint color
    [UITableView appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = _accentTintColor;

    // set the view tint
    self.view.tintColor = _accentTintColor;
}

// Adjust labels when loading the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
    cell.textLabel.textColor = _accentTintColor;
    return cell;
}

// setup actions for the preview
- (NSArray<id<UIPreviewActionItem> > *)previewActionItems {

    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Open" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [self.parentController.navigationController pushViewController:self animated:YES];
    }];

    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Reset" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [self setValueForSpecifier:self.specifier defaultValue:[self.specifier propertyForKey:PSDefaultValueKey]];
        [(PSListController *) self.parentController reloadSpecifier:self.specifier];
    }];

    NSArray *actions = @[action1, action2];

    return actions;
}

@end
