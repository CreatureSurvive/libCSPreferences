/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   11-08-2017 9:51:54
 * @Email:  dbuehre@me.com
 * @Filename: CSPMailComposeManager.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:50
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import <MessageUI/MFMailComposeViewController.h>
#import <Preferences/PSSpecifier.h>

@interface CSPMailComposeManager : NSObject
+ (MFMailComposeViewController *)mailComposeControllerForSpecifier:(PSSpecifier *)specifier delegate:(id)delegate;
@end
