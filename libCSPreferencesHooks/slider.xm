/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   yyyy-06-Sa 7:05:32
 * @Email:  dbuehre@me.com
 * @Project: motuumLS
 * @Filename: slider.x
 * @Last modified by:   creaturesurvive
 * @Last modified time: 12-09-2017 12:06:13
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


 #import <Preferences/PSSliderTableCell.h>
 #import <Preferences/PSDiscreteSlider.h>
 #define roundToNearest(x, y)(floor(x / y + 0.5) * y)

#pragma mark Slider Entries

@interface CSAccurateSliderEntry : NSObject
@property (nonatomic) float value;
@property (nonatomic) NSTimeInterval startingTime;
@property (nonatomic) NSTimeInterval duration;
@end

@implementation CSAccurateSliderEntry
- (NSString *)description {
    return [ @{ @"value" : @(self.value),
                @"startingTime" : @(self.startingTime),
                @"duration" : @(self.duration) } description];
}

@end

#pragma mark Slider

@interface PSSegmentableSlider : UISlider
@property(nonatomic, retain) NSMutableArray *entries;
// @property(nonatomic, assign) UIPanGestureRecognizer *smoothing;
- (void)mls_showValueEntryPopup;
- (CGRect)currentThumbRect;
- (void)addNewEntry;
- (void)correctValueIfNeeded;
- (void)updateLastEntryDuration;
- (NSMutableArray *)entries;
@end

#pragma mark Hook

%hook PSSegmentableSlider
%property(nonatomic, retain) NSMutableArray *entries;
// %property(nonatomic, assign) UIPanGestureRecognizer *smoothing;

#pragma mark Init

- (void)didMoveToSuperview {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
}

#pragma mark gestures
%new - (void)didRecognizePan: (UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint velocity = [sender velocityInView:self];

        if (velocity.x > 0) {
            [self setValue:self.value + 0.0005f animated:YES];
        } else {
            [self setValue:self.value - 0.0005f animated:YES];
        }

    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

%new - (void)doubleTapGesture: (UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self mls_showValueEntryPopup];
    }
}

#pragma mark Accuracy

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL retVal = %orig(touch, event);

    if (retVal) {
        // reset entries from the previous touch
        self.entries = nil;

        [self addNewEntry];
    }

    return retVal;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL retVal = %orig(touch, event);

    if (retVal) {
        [self updateLastEntryDuration];
        [self addNewEntry];
    }

    return retVal;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    %orig(touch, event);

    [self updateLastEntryDuration];
    [self correctValueIfNeeded];
}

#pragma mark - Properties

- (NSMutableArray *)entries {
    if (!self.entries) {
        self.entries = [[NSMutableArray alloc] init];
    }

    return self.entries;
}

#pragma mark - Private

%new - (void)addNewEntry {
    CSAccurateSliderEntry *newEntry = [[CSAccurateSliderEntry alloc] init];
    newEntry.value = roundToNearest(self.value, 0.0005f);
    newEntry.startingTime = CACurrentMediaTime();
    [self.entries addObject:newEntry];
}

%new - (void)correctValueIfNeeded {
    static const CGFloat kAcceptableLocationDelta = 12.0f;
    __block float properSliderValue = FLT_MIN;

    // finds the newest entry with a duration longer than 0.05s
    [self.entries enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CSAccurateSliderEntry *entry, NSUInteger idx, BOOL *stop) {
        if (entry.duration > 0.05) {

            CGFloat width = CGRectGetWidth(self.frame);
            CGFloat valueDelta = fabsf(entry.value - self.value);
            CGFloat sliderRange = fabsf(self.maximumValue - self.minimumValue);
            CGFloat locationDelta = valueDelta / sliderRange * width;

            // assume this value as the one user tried to select if it's close enough to the value after the touch has ended
            if (locationDelta < kAcceptableLocationDelta) {
                properSliderValue = entry.value;
            }

            *stop = YES;
        }
    }];
    // correct the value
    if (properSliderValue != FLT_MIN) {
        [self setValue:properSliderValue animated:YES];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    } else {// round the value
        [self setValue:roundToNearest(self.value, 0.0005f)];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

%new - (void)updateLastEntryDuration {
    CSAccurateSliderEntry *lastEntry = [self.entries lastObject];
    lastEntry.duration = CACurrentMediaTime() - lastEntry.startingTime;
}

- (CGRect)currentThumbRect {
    return [self thumbRectForBounds:self.bounds trackRect:[self trackRectForBounds:self.bounds] value:self.value];
}

%new - (void)mls_showValueEntryPopup {
    // CGFloat rangeMultiplier = self.maximumValue == 1 ? 100 : 1;
    NSString *title = [NSString stringWithFormat:@"Range(%.2f - %.2f)", self.minimumValue, self.maximumValue];

    NSBundle *uikitBundle = [NSBundle bundleWithIdentifier:@"com.apple.UIKit"];
    NSString *ok = [uikitBundle localizedStringForKey:@"OK" value:@"" table:@"Localizable"];
    NSString *cancel = [uikitBundle localizedStringForKey:@"Cancel" value:@"" table:@"Localizable"];

    // set up the alert controller. if there is an accessibilityLabel, use that as the title and our
    // title as subtitle. otherwise, just use our title
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.accessibilityLabel ? : title message:self.accessibilityLabel ? title : nil preferredStyle:UIAlertControllerStyleAlert];

    // insert our text box
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // set to a decimal pad keyboard
        textField.keyboardType = UIKeyboardTypeDecimalPad;

        // limit to 2 decimal places, because floats are fun
        // CGFloat multiplier = self.maximumValue == 1 ? 100 : 1;

        textField.text = [NSString stringWithFormat:@"%.4f", self.value];
    }];

    // insert our ok button
    [alertController addAction:[UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // CGFloat multiplier = self.maximumValue == 1 ? 0.01 : 1;
        // set the value
        self.value = alertController.textFields[0].text.floatValue;

        // fire the callback so it gets stored
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }]];

    // same for cancel
    [alertController addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:nil]];

    // grab the root window and display it
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

%end
