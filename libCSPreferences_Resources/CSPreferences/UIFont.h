/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   04-09-2017 2:24:47
 * @Email:  dbuehre@me.com
 * @Filename: UIFont.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 16-09-2017 10:21:57
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


@interface UIFont (CustomFont)
+ (NSArray *)customFonts;
+ (void)refreshCustomFonts;
+ (UIFont *)loadFontWithName:(NSString *)fontName size:(CGFloat)fontSize;
@end
