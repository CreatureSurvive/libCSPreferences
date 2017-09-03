/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   11-08-2017 9:54:24
 * @Email:  dbuehre@me.com
 * @Filename: CSPMailComposeManager.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:56
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "CSPMailComposeManager.h"

@implementation CSPMailComposeManager

// IDEA add support for attatchments
+ (MFMailComposeViewController *)mailComposeControllerForSpecifier:(PSSpecifier *)specifier delegate:(id)delegate {
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = delegate;

    NSURLComponents *components = [NSURLComponents componentsWithString:[specifier propertyForKey:@"mailto"]];
    NSString *toRecipients = components.path;

    for (NSURLQueryItem *param in components.queryItems) {
        if ([param.name isEqualToString:@"to"]) {
            toRecipients = [NSString stringWithFormat:@"%@,%@", components.path, param.value];
        }

        if ([param.name isEqualToString:@"subject"]) {
            [mailViewController setSubject:param.value];
        }

        if ([param.name isEqualToString:@"body"]) {
            [mailViewController setMessageBody:param.value isHTML:NO];
        }

        if ([param.name isEqualToString:@"cc"]) {
            [mailViewController setCcRecipients:[param.value componentsSeparatedByString:@","]];
        }

        if ([param.name isEqualToString:@"bcc"]) {
            [mailViewController setBccRecipients:[param.value componentsSeparatedByString:@","]];
        }
    }
    [mailViewController setToRecipients:[toRecipients componentsSeparatedByString:@","]];

    return mailViewController;
}

@end
