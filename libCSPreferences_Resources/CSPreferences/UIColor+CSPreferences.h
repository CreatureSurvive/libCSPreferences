/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   24-09-2017 12:00:41
 * @Email:  dbuehre@me.com
 * @Filename: UIColor.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 24-09-2017 12:15:44
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


@interface UIColor (CSPColorFromHex)

// returns a UIColor from the hex string eg [UIColor colorFromHexString:@"#FF0000"];
// if the hex string is invalid, returns red
// supported formats include 'RGB', 'ARGB', 'RRGGBB', 'AARRGGBB', 'RGB:0.500000', 'RRGGBB:0.500000'
// all formats work with or without #
+ (UIColor *)csp_colorFromHexString:(NSString *)hexString;

// returns a NSString representation of a UIColor in hex format eg [UIColor hexStringFromColor:[UIColor redColor]]; outputs @"#FF0000"
+ (NSString *)csp_hexStringFromColor:(UIColor *)color;

// returns a NSString representation of a UIColor in hex format eg [UIColor hexStringFromColor:[UIColor redColor] alpha:YES]; outputs @"#FF0000FF"
+ (NSString *)csp_hexStringFromColor:(UIColor *)color alpha:(BOOL)include;

// returns the brightness of the color where black = 0.0 and white = 256.0
// credit goes to https://w3.org for the algorithm
+ (CGFloat)csp_brightnessOfColor:(UIColor *)color;

// returns true if the color is light using brightnessOfColor > 0.5
+ (BOOL)csp_isColorLight:(UIColor *)color;

// returns true if the string is a valid hex (will pass with or without #)
+ (BOOL)csp_isValidHexString:(NSString *)hexStr;

// returns an array of UIColors from a comma seporated string of hex colors
+ (NSArray<UIColor *> *)csp_gradientStringColors:(NSString *)colorsString;

// returns an array of CGColors from a comma seporated string of hex colors
+ (NSArray<id> *)csp_gradientStringCGColors:(NSString *)colorsString;

// the alpha component the color instance
- (CGFloat)csp_alpha;

// the red component the color instance
- (CGFloat)csp_red;

// the green component the color instance
- (CGFloat)csp_green;

// the blue component the color instance
- (CGFloat)csp_blue;

// the hue component the color instance
- (CGFloat)csp_hue;

// the saturation component the color instance
- (CGFloat)csp_saturation;

// the brightness component the color instance
- (CGFloat)csp_brightness;

@end
