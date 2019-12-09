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


// initialization
- (instancetype)init;
- (instancetype)initWithPlistName:(NSString *)plist inBundle:(NSBundle *)bundle;
- (instancetype)initWithSpecifier:(PSSpecifier *)specifier;

// bundle specific paths
- (NSBundle *)preferenceBundle;
- (NSString *)preferencePath;
- (NSString *)cacheDirectoryPath;
- (NSString *)preferencePathForSpecifier:(PSSpecifier *)specifier;

// specifier convenience
- (void)resetSpecifier:(PSSpecifier *)specifier;

- (void)refreshCellWithSpecifier:(PSSpecifier *)specifier;
- (void)refreshAllSpecifiersAnimated:(BOOL)animated;
- (void)refreshAllSpecifiersAnimated:(BOOL)animated;

- (id)defaultValueForSpecifier:(PSSpecifier *)specifier;

- (void)setProperty:(id)property forSpecifiers:(NSArray *)specifiers;

- (NSArray *)specifiersInGroup:(long long)group excludingTypes:(NSArray *)excluded;
- (NSArray *)specifiersInGroup:(long long)group explicitTypes:(NSArray *)included;
- (NSArray *)specifiersForKey:(NSString *)key;

@end

@interface CSPDeveloperCell : PSTableCell
@end

@interface CSPBrowserPreviewController : PSViewController
@end

@interface CSListItemsController : PSListItemsController
@end

@interface CSListFontsController : PSListItemsController
@end
