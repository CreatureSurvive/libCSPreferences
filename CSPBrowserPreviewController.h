/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   08-07-2017 12:03:25
 * @Email:  dbuehre@me.com
 * @Filename: CSPBrowserPreviewController.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 09-07-2017 9:36:15
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */
#import <UIKit/UIKit.h>
#import "CSPCommon.h"

@interface CSPBrowserPreviewController : PSViewController
- (id)initWithURL:(NSString *)url;
- (NSString *)url;
@end
