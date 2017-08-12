//
// Created by Dana Buehre on 6/17/17.
// Copyright (c) 2017 CreatureCoding. All rights reserved.
//

#import "UIColor+ColorFromHex.h"

@implementation UIColor (ColorFromHex)

+ (UIColor *)colorFromHex:(int)hex {
    return [UIColor colorWithRed:((hex & 0xFF000000) >> 24)/255.0f
                           green:((hex & 0xFF0000) >> 16)/255.0f
                            blue:((hex & 0xFF00) >> 8)/255.0f
                           alpha:(hex & 0xFF)/255.0f];
}

+ (UIColor *)colorFromHex:(int)hex WithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((hex & 0xFF0000) >> 16)/255.0f
                           green:((hex & 0xFF00) >> 8)/255.0f
                            blue:(hex & 0xFF)/255.0f
                           alpha:alpha];
}

+ (UIColor *)colorFromHexShort:(int)hex WithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((hex & 0xF00) >> 16)/255.0f
                           green:((hex & 0xF0) >> 8)/255.0f
                            blue:(hex & 0xF)/255.0f
                           alpha:alpha];
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
            return [UIColor colorFromHexShort:rgbValue WithAlpha:alpha];
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

@end
