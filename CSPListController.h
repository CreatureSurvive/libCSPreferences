/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   01-07-2017 10:49:52
 * @Email:  dbuehre@me.com
 * @Project: motuumLS
 * @Filename: CSPListController.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 08-07-2017 5:32:42
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#import <UIKit/UIKit.h>
#include <spawn.h>
#include "CSPCommon.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface CSPListController : PSListController <UITableViewDelegate, UIViewControllerPreviewingDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) id previewingContext;
- (id)initWithPlistName:(NSString *)plist;
- (void)refreshCellWithSpecifier:(PSSpecifier *)specifier;
- (void)openURLInBrowser:(NSString *)url;
@end
