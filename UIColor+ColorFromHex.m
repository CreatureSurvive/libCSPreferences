//
// Created by Dana Buehre on 6/17/17.
// Copyright (c) 2017 CreatureCoding. All rights reserved.
//

#import "UIColor+ColorFromHex.h"

@implementation UIColor (ColorFromHex)

int length(int i) {
	if (i < 0) i = -i;
	if (i <         10) return 1;
	if (i <        100) return 2;
	if (i <       1000) return 3;
	if (i <      10000) return 4;
	if (i <     100000) return 5;
	if (i <    1000000) return 6;      
	if (i <   10000000) return 7;
	if (i <  100000000) return 8;
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

@end
