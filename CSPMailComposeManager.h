#import <MessageUI/MFMailComposeViewController.h>
#import <Preferences/PSSpecifier.h>

@interface CSPMailComposeManager : NSObject
+ (MFMailComposeViewController *)mailComposeControllerForSpecifier:(PSSpecifier *)specifier delegate:(id)delegate;
@end
