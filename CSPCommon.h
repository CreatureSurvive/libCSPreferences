/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   01-07-2017 5:45:14
 * @Email:  dbuehre@me.com
 * @Filename: CSPCommon.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 12-09-2017 11:56:11
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


//TODO seporate public and private
//TODO define headers within the project rather than using include directory
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSListItemsController.h>

#import <CSColorPicker.h>

#import "UIColor+ColorFromHex.h"
#import "libCSPreferencesHooks/UIFont.h"

#import <SafariServices/SafariServices.h>

#import "CSListItemsController.h"
#import "CSListFontsController.h"

#import "CSPListController.h"
#import "CSPBrowserPreviewController.h"

#import "CSPBackupListViewController.h"
#import "CSPChangeLogController.h"
#import "CSPColorPreviewController.h"

#import "CSPDeveloperCell.h"
#import "CSPValueCell.h"
#import "CSPDatePickerCell.h"

// #define _plistfile (@"/User/Library/Preferences/com.creaturesurvive.fastdel.plist")
// #define _prefsChanged (@"com.creaturesurvive.fastdel.prefschanged")
// #define _bundleID (@"com.creaturesurvive.fastdel")

 #define _accentTintColor [UIColor colorWithRed:0.2905 green:0.5632 blue:0.8872 alpha:1.0000]
