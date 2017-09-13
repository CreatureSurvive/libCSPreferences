/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   02-07-2017 5:12:52
 * @Email:  dbuehre@me.com
 * @Filename: UIColor+ColorFromHex.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 12-09-2017 12:05:08
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (ColorFromHex)

//returns a UIColor from the passed hex value eg [UIColor colorWithHex:0x6BB9F0FF] using the last 2 digits as the alpha;
+ (UIColor *)colorFromHex:(int)hex;

//returns a UIColor from the passed hex value eg [UIColor colorWithHex:0x6BB9F0 WithAlpha:1];
+ (UIColor *)colorFromHex:(int)hex WithAlpha:(CGFloat)alpha;

//returns a UIColor with alpha control from the passed hex string eg [UIColor colorFromHexString:@"#6BB9F0:0.500000"];
+ (UIColor *)colorFromHexString:(NSString *)hexString;

//returns a UIColor from the passed hex string with alpha control eg [UIColor colorFromHexString:@"#6BB9F0 alpha:0.5f"];
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (NSString *)hexStringFromColor:(UIColor *)color;

+ (NSString *)informationStringForColor:(UIColor *)color;

+ (BOOL)isColorLight:(UIColor *)color;
@end
