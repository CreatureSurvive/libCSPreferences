/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   10-09-2017 5:12:24
 * @Email:  dbuehre@me.com
 * @Filename: PSSliderTableCell.xm
 * @Last modified by:   creaturesurvive
 * @Last modified time: 11-09-2017 11:53:31
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface PSSegmentableSlider : UISlider
@end

%hook PSSliderTableCell

- (id)newControl {
    if ([self.specifier propertyForKey:PSSliderIsContinuous]) {
        PSSegmentableSlider *slider = %orig;
        slider.continuous = [[self.specifier propertyForKey:PSSliderIsContinuous] boolValue];
        return slider;
    }
    return %orig;
}

- (id)control {
    if ([self.specifier propertyForKey:PSSliderIsContinuous]) {
        PSSegmentableSlider *slider = %orig;
        slider.continuous = [[self.specifier propertyForKey:PSSliderIsContinuous] boolValue];
        return slider;
    }
    return %orig;
}

%end
