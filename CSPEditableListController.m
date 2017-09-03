/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   31-08-2017 8:23:21
 * @Email:  dbuehre@me.com
 * @Filename: CSPEditableListController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:19
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "CSPEditableListController.h"

@implementation CSPEditableListController

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSSpecifier *specifier = [self specifierAtIndexPath:indexPath];
    if ([specifier propertyForKey:@"lockEditing"] && [[specifier propertyForKey:@"lockEditing"] boolValue]) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    PSSpecifier *specifier = [self specifierAtIndexPath:indexPath];
    if ([specifier propertyForKey:@"lockEditing"] && [[specifier propertyForKey:@"lockEditing"] boolValue]) {
        return NO;
    }
    return YES;
}

@end
