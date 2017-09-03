/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   01-09-2017 11:00:18
 * @Email:  dbuehre@me.com
 * @Filename: PSViewController.xm
 * @Last modified by:   creaturesurvive
 * @Last modified time: 02-09-2017 9:59:26
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "../UIColor+ColorFromHex.h"
#import <Preferences/PSSpecifier.h>


@interface PSViewController : UIViewController
@property (nonatomic, retain) PSSpecifier *specifier;
@property (nonatomic, retain) PSViewController *parentController;
- (PSSpecifier *)specifier;
- (id)parentController;
@end

@interface PSListController : PSViewController
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) UIColor *tintColor;
- (void)setTintEnabled:(BOOL)enabled;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end


%hook PSListController
%property(nonatomic, retain) UIColor *tintColor;

- (void)viewWillAppear:(BOOL)animated {
    [self setTintEnabled:YES];
    %orig(animated);
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig(animated);
    [self setTintEnabled:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = %orig(tableView, indexPath);
    if (self.tintColor) {
        cell.textLabel.textColor = self.tintColor;
    }
    return cell;
}

// sets the tint colors for the view
%new
- (void)setTintEnabled: (BOOL)enabled {
    NSBundle *bundle;

    if ([self.specifier propertyForKey:@"tintColor"]) {
        self.tintColor = [UIColor colorFromHexString:[self.specifier propertyForKey:@"tintColor"]];
    } else if ([[self parentController] respondsToSelector:@selector(bundle)]) {
        bundle = [(PSListController *)[self parentController] bundle];
    } else if ([self respondsToSelector:@selector(bundle)]) {
        bundle = [self bundle];
    }

    if (bundle) {
        NSDictionary *globals = [NSDictionary dictionaryWithContentsOfFile:[bundle pathForResource:@"globals" ofType:@"plist"]] ? : nil;
        if (globals && globals[@"globalTintColor"]) {
            self.tintColor = [UIColor colorFromHexString:globals[@"globalTintColor"]];
        }
    }

    if (enabled && self.tintColor) {
        // tintColor = [UIColor colorFromHexString:[self.specifier propertyForKey:@"tintColor"]];
        // Color the navbar
        self.navigationController.navigationController.navigationBar.tintColor = self.tintColor;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.tintColor};

        // set cell control colors
        [UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = self.tintColor;
        [UITableView appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = self.tintColor;
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].textColor = self.tintColor;
        [UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = self.tintColor;
        // [self setSegmentedSliderTrackColor:tintColor];

        // set the view tint
        self.view.tintColor = self.tintColor;
    } else {
        // Un-Color the navbar when leaving the view
        self.navigationController.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;

        // Un-Color the controls when leaving the view
        [UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = nil;
        [UITableView appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = nil;
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].textColor = nil;
        [UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = nil;
        // [self setSegmentedSliderTrackColor:nil];

    }
}

%end
