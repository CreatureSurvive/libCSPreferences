/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   07-07-2017 12:32:06
 * @Email:  dbuehre@me.com
 * @Filename: CSListFontsController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:38:41
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#import "CSListFontsController.h"

@implementation CSListFontsController


// set the tint colors before the view appears
- (void)viewDidLoad {
    [super viewDidLoad];
    // [self setTint];
}

// sets the tint colors for the view
// - (void)setTint {
//     if ([self.specifier propertyForKey:@"tintColor"] || self.tintColor) {
//
//         _tintColor = [self.specifier propertyForKey:@"tintColor"] ? [UIColor colorFromHexString:[self.specifier propertyForKey:@"tintColor"]] :
//                      self.tintColor ? : nil;
//
//         if (!_tintColor) return;
//
//         // Color the navbar
//         self.navigationController.navigationController.navigationBar.tintColor = _tintColor;
//         self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : _tintColor};
//
//         // set tableView tint color
//         [UITableView appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = _tintColor;
//
//         // set the view tint
//         self.view.tintColor = _tintColor;
//     }
// }

// Adjust labels when loading the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    // [cell.textLabel setAdjustsFontSizeToFitWidth:YES]; 
    cell.textLabel.textColor = self.tintColor;
    cell.textLabel.font = [UIFont fontWithName:cell.textLabel.text size:20];
    return cell;
}

// call refreshParentCell when selecting a value
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self refreshParentCell];
}

// refresh the cell in the parentController
- (void)refreshParentCell {
    [(CSPListController *) self.parentController refreshCellWithSpecifier:self.specifier];
}

// setup actions for the preview
- (NSArray<id<UIPreviewActionItem> > *)previewActionItems {

    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Open" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [self.parentController.navigationController pushViewController:self animated:YES];
    }];

    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Reset" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [self setValueForSpecifier:self.specifier defaultValue:[self.specifier propertyForKey:PSDefaultValueKey]];
        [self refreshParentCell];
    }];

    NSArray *actions = @[action1, action2];

    return actions;
}

@end
