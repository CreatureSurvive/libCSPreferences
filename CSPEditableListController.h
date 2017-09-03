/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   31-08-2017 8:21:48
 * @Email:  dbuehre@me.com
 * @Filename: CSPEditableListController.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 01-09-2017 8:43:27
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


 #import <Preferences/PSEditableListController.h>
 #import <Preferences/PSSpecifier.h>

@interface CSPEditableListController : PSEditableListController
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
