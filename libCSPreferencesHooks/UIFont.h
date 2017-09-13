/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   04-09-2017 2:24:47
 * @Email:  dbuehre@me.com
 * @Filename: UIFont.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 04-09-2017 2:44:09
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


@interface UIFont (CustomFont)
+ (BOOL)registerFromURL:(NSURL *)fontURL;
+ (NSArray *)registerFontFromURL:(NSURL *)fontURL;
+ (NSArray *)customFonts;
+ (void)registerFonts;
@end
