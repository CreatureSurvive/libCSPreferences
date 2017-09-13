/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   04-09-2017 12:56:27
 * @Email:  dbuehre@me.com
 * @Filename: SBAlert.xm
 * @Last modified by:   creaturesurvive
 * @Last modified time: 04-09-2017 4:35:04
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */
#import "UIFont.h"
@interface SBSearchEtceteraDateViewController : UIViewController
- (id)_dateLabelFont;
@end

%hook SBSearchEtceteraDateViewController

- (id)_dateLabelFont {
    [UIFont registerFonts];
    if ([UIFont fontWithName:@"Slackey-Regular" size:20]) {
        return [UIFont fontWithName:@"Slackey-Regular" size:20];
    } else {
        return [UIFont systemFontOfSize:20];
    }
}
%end
