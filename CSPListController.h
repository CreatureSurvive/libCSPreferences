/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   01-07-2017 10:49:52
 * @Email:  dbuehre@me.com
 * @Filename: CSPListController.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 11-09-2017 8:33:04
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#import <UIKit/UIKit.h>
#include <spawn.h>
#include "CSPCommon.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "CSPMailComposeManager.h"

@interface CSPListController : PSListController <UITableViewDelegate, UIViewControllerPreviewingDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary *settings;
@property (nonatomic, strong) id previewingContext;
- (id)initWithPlistName:(NSString *)plist inBundle:(NSBundle *)bundle;
- (void)refreshCellWithSpecifier:(PSSpecifier *)specifier;
- (void)openURLInBrowser:(NSString *)url;
- (UIColor *)globalTintColor;
@end
