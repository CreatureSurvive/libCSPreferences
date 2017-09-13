/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   04-09-2017 12:45:23
 * @Email:  dbuehre@me.com
 * @Filename: UIFont+CustomFont.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 04-09-2017 2:18:34
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


@interface UIFont (CustomFont)
+ (BOOL)registerFromURL:(NSURL *)fontURL;
+ (NSArray *)registerFontFromURL:(NSURL *)fontURL;
+ (NSArray *)customFonts;
@end
