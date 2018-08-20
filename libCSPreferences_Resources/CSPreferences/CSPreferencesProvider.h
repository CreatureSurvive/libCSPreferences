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
- (id)   initWithTweakID:(NSString *)identifier
            defaultsPath:(NSString *)defaultsPath
        postNotification:(NSString *)notification
    notificationCallback:(void (^)(CSPreferencesProvider *))callback;

- (id)   initWithTweakID:(NSString *)identifier
                defaults:(NSDictionary *)defaultValues
        postNotification:(NSString *)notification
    notificationCallback:(void (^)(CSPreferencesProvider *))callback;

// Convenience
// Fetching Values
- (id)          objectForKey:   (NSString *)key;
- (NSString *)  stringForKey:   (NSString *)key;
- (BOOL)        boolForKey:     (NSString *)key;
- (float)       floatForKey:    (NSString *)key;
- (double)      doubleForKey:   (NSString *)key;
- (int)         intForKey:      (NSString *)key;
- (UIColor *)   colorForKey:    (NSString *)key;

// Setting Values
- (void)setObject:              (id)obj         forKey:(NSString *)key;
- (void)removeObjectForKey:     (NSString *)key;

// Saving Values
- (void)save;
- (void)saveAndPostNotification;
- (void)postNotification;

// Custom Controller
- (id)readPreferenceValue:      (id)specifier;
- (void)setPreferenceValue:     (id)value       specifier:(id)specifier;

@end
