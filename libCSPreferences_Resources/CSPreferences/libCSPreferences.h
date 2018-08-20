#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSListItemsController.h>

@interface CSPListController : PSListController

// Convenience
// Fetching Values
- (id)          objectForKey:   (NSString *)key;
- (NSString *)  stringForKey:   (NSString *)key;
- (BOOL)        boolForKey:     (NSString *)key;
- (float)       floatForKey:    (NSString *)key;
- (double)      doubleForKey:   (NSString *)key;
- (int)         intForKey:      (NSString *)key;
- (UIColor *)   colorForKey:    (NSString *)key;
@end

@interface CSPDeveloperCell : PSTableCell
@end

@interface CSPBrowserPreviewController : PSViewController
@end

@interface CSListItemsController : PSListItemsController
@end

@interface CSListFontsController : PSListItemsController
@end
