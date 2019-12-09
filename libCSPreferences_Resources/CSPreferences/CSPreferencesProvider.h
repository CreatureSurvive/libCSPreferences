/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   17-09-2017 2:49:18
 * @Email:  dbuehre@me.com
 * @Filename: CSPreferencesProvider.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 24-09-2017 12:37:48
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#import <Preferences/PSSpecifier.h>
#import "UIColor+CSPreferences.h"

@interface CSPreferencesProvider : NSObject
@property (nonatomic, copy)     NSDictionary    *defaults;
@property (nonatomic, retain)   NSString        *plistPath;

// initialization
- (id)initWithTweakID:(NSString *)identifier
         defaultsPath:(NSString *)defaultsPath
     postNotification:(NSString *)notification
 notificationCallback:(void (^)(CSPreferencesProvider *))callback;

- (id)initWithTweakID:(NSString *)identifier
             defaults:(NSDictionary *)defaultValues
     postNotification:(NSString *)notification
 notificationCallback:(void (^)(CSPreferencesProvider *))callback;

// Convenience
// Fetching Values

// object value for key
- (id)objectForKey:(NSString *)key;
// string value for key
- (NSString *)stringForKey:(NSString *)key;
// boolean value for key
- (BOOL)boolForKey:(NSString *)key;
// float value for key
- (float)floatForKey:(NSString *)key;
// double value for key
- (double)doubleForKey:(NSString *)key;
// int value for key
- (int)intForKey:(NSString *)key;
// UIColor value for key
- (UIColor *)colorForKey:(NSString *)key;
// UIColor value for hex string (convenience)
- (UIColor *)colorForHex:(NSString *)key;
// array of UIColor values for key saved value should be a comma separated sting of hex colors
- (NSArray<UIColor *> *)colorsForKey:(NSString *)key;
// array of CGColor values for key saved value should be a comma separated sting of hex colors
- (NSArray<id> *)CGcolorsForKey:(NSString *)key;

// Font Loading (Custom || System)
- (UIFont *)fontForFamilyKey:   (NSString *)familyKey   sizeKey:(NSString *)sizeKey;
- (UIFont *)fontForFamilyKey:   (NSString *)familyKey   size:(double)size;
- (UIFont *)fontForFamilyName:  (NSString *)family      size:(double)size;

// Setting Values
- (void)setObject:              (id)obj             forKey:(NSString *)key;
- (void)setObject:              (id)obj             forKey:(NSString *)key         andSave:(BOOL)save;
- (void)removeObjectForKey:     (NSString *)key;
- (void)removeObjectForKey:     (NSString *)key     andSave:(BOOL)save;

// Saving Values
- (void)save;
- (void)saveAndPostNotification;
- (void)postNotification;

// Custom Controller
- (id)readPreferenceValue:      (id)specifier;
- (void)setPreferenceValue:     (id)value       specifier:(id)specifier;

@end
