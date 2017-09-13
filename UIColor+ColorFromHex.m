/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   18-08-2017 12:14:22
 * @Email:  dbuehre@me.com
 * @Filename: UIColor+ColorFromHex.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 12-09-2017 12:13:19
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "UIColor+ColorFromHex.h"

@implementation UIColor (ColorFromHex)

int length(int i) {
    if (i < 0) i = -i;
    if (i < 10) return 1;
    if (i < 100) return 2;
    if (i < 1000) return 3;
    if (i < 10000) return 4;
    if (i < 100000) return 5;
    if (i < 1000000) return 6;
    if (i < 10000000) return 7;
    if (i < 100000000) return 8;
    if (i < 1000000000) return 9;
    return 10;
}

+ (UIColor *)colorFromHex:(int)hex {
    return [UIColor colorWithRed:((hex & 0xFF000000) >> 24)/255.0f
                           green:((hex & 0xFF0000) >> 16)/255.0f
                            blue:((hex & 0xFF00) >> 8)/255.0f
                           alpha:(hex & 0xFF)/255.0f];
}

+ (UIColor *)colorFromHex:(int)hex WithAlpha:(CGFloat)alpha {
    switch (length(hex)) {
        case 4:
        case 5:
            return [UIColor colorWithRed:((hex & 0xF00) >> 8)*17/255.0f
                                   green:((hex & 0xF0) >> 4)*17/255.0f
                                    blue:(hex & 0xF)*17/255.0f
                                   alpha:alpha];
        case 7:
        case 8:
            return [UIColor colorWithRed:((hex & 0xFF0000) >> 16)/255.0f
                                   green:((hex & 0xFF00) >> 8)/255.0f
                                    blue:(hex & 0xFF)/255.0f
                                   alpha:alpha];
        case 9:
        case 10:
            return [UIColor colorFromHex:hex];
        default:
            return [UIColor redColor];
    }
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    CGFloat alpha = 1;
    NSString *color = @"FF0000";

    if (hexString && hexString.length > 0) {

        NSArray *RGBA = [hexString componentsSeparatedByString:@":"];
        if ([hexString rangeOfString:@":"].location != NSNotFound) {

            alpha = RGBA[1] ? [RGBA[1] floatValue] : 1;
        }
        color = RGBA[0];
    }

    return [UIColor colorFromHexString:color alpha:alpha];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {

    BOOL hasTag = [[hexString substringToIndex:1] isEqual:@"#"];
    hexString = hasTag ? [hexString substringFromIndex:1] : hexString;

    if (![self isValidHexString:hexString]) {
        return [UIColor colorWithRed:1 green:0 blue:0 alpha:alpha];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];

    switch (hexString.length) {
        case 3:
        case 6:
            return [UIColor colorFromHex:rgbValue WithAlpha:alpha];
        case 8:
            return [UIColor colorFromHex:rgbValue];
        default:
            return [UIColor redColor];
    }
}

+ (BOOL)isValidHexString:(NSString *)hexStr {
    NSCharacterSet *hexChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
    return (NSNotFound == [hexStr rangeOfCharacterFromSet:hexChars].location);
}

+ (NSString *)hexStringFromColor:(UIColor *)color {

    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    red = roundf(red * 255.0f);
    green = roundf(green * 255.0f);
    blue = roundf(blue * 255.0f);

    return [[[NSString alloc] initWithFormat:@"%02x%02x%02x", (int)red, (int)green, (int)blue] uppercaseString];
}

+ (NSString *)informationStringForColor:(UIColor *)color {
    CGFloat h, s, b, a, r, g, bb, aa;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    [color getRed:&r green:&g blue:&bb alpha:&aa];
    // if (wide) {
    //     return [NSString stringWithFormat:@"#%@\n\nR: %.f       H: %.f\nG: %.f       S: %.f\nB: %.f       B: %.f", [UIColor hexStringFromColor:color], r * 255, h * 360, g * 255, s * 100, bb * 255, b * 100];
    // }
    return [NSString stringWithFormat:@"#%@\n\nR: %.f\nG: %.f\nB: %.f\nA: %.f\n\nH: %.f\nS: %.f\nB: %.f\nA: %.f", [UIColor hexStringFromColor:color], r * 255, g * 255, bb * 255, aa * 100, h * 360, s * 100, b * 100, a * 100];
}

+ (BOOL)isColorLight:(UIColor *)color {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    CGFloat brightness = (((red * 255) * 299) + ((green * 255) * 587) + ((blue * 255) * 114)) / 1000;

    return (brightness >= 128.0);
}

@end
