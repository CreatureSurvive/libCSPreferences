/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   18-08-2017 12:14:22
 * @Email:  dbuehre@me.com
 * @Filename: libCSPreferences.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:40:23
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSListItemsController.h>

@interface CSPListController : PSListController
@end

@interface CSPDeveloperCell : PSTableCell
@end

@interface CSPBrowserPreviewController : PSViewController
@end

@interface CSListItemsController : PSListItemsController
@end

@interface CSListFontsController : PSListItemsController
@end
