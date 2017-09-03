/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   01-07-2017 10:49:52
 * @Email:  dbuehre@me.com
 * @Filename: CSPListController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:46
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#include "CSPListController.h"
#import "AudioToolbox/AudioToolbox.h"


@implementation CSPListController {

    NSMutableDictionary *_settings;
    NSArray *_fontNames;
    CSPListController *_child;
    NSCache *_avatarCache;
    NSString *_cacheDirectoryPath;
    NSBundle *_bundle;
    UIColor *_tintColor;
    UIColor *_globalTintColor;
    BOOL _refreshQueued;
}

#pragma mark Initialize
// Initialize the settings dictionary
- (id)init {
    if ((self = [super init]) != nil) {
        [self setup];
    }

    return self;
}

- (id)initWithPlistName:(NSString *)plist inBundle:(NSBundle *)bundle {
    if ((self = [super init]) != nil) {
        [self setup];
        _bundle = bundle;
        _specifiers = [self loadSpecifiersFromPlistName:plist target:self bundle:_bundle];
    }

    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotification:) name:@"kCSPReloadSettings" object:nil];
    _bundle = [self bundle];

    _settings = [NSMutableDictionary dictionaryWithContentsOfFile:[self preferencePath]] ? : [NSMutableDictionary dictionary];
    _tintColor = nil;
}

- (void)recievedNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"kCSPReloadSettings"]) {
        _settings = [NSMutableDictionary dictionaryWithContentsOfFile:[self preferencePath]] ? : [NSMutableDictionary dictionary];
        _refreshQueued = YES;
    }
}

// return the specifiers from .plist
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }

    return _specifiers;
}

- (NSString *)preferencePath {
    return [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", _bundle.bundleIdentifier];
}

- (NSString *)cacheDirectoryPath {
    if (!_cacheDirectoryPath) {
        _cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return _cacheDirectoryPath;
}

#pragma mark Load View

// tint the view after it loads
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_refreshQueued) {
        [self refreshAllSpecifiersAnimated:NO];
    }
    [self setTintEnabled:YES];
    [self setupHeader];
}

// remove tint wen leaving the view
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setTintEnabled:NO];
}

- (UIColor *)globalTintColor {
    if (!_globalTintColor) {
        NSDictionary *globals = [NSDictionary dictionaryWithContentsOfFile:[_bundle pathForResource:@"globals" ofType:@"plist"]] ? : nil;
        if (globals && globals[@"globalTintColor"]) {
            _globalTintColor = [UIColor colorFromHexString:globals[@"globalTintColor"]];
        }
    }
    return _globalTintColor;
}

// sets the tint colors for the view
- (void)setTintEnabled:(BOOL)enabled {
    _tintColor = [self.specifier propertyForKey:@"tintColor"] ? [UIColor colorFromHexString:[self.specifier propertyForKey:@"tintColor"]] :
                 [self globalTintColor] ? : nil;
    if (enabled && _tintColor) {
        // Color the navbar
        self.navigationController.navigationController.navigationBar.tintColor = _tintColor;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : _tintColor};

        // set cell control colors
        [UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = _tintColor;
        [UITableView appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = _tintColor;
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].textColor = _tintColor;
        [UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = _tintColor;
        [self setSegmentedSliderTrackColor:_tintColor];

        // set the view tint
        self.view.tintColor = _tintColor;
    } else {
        // Un-Color the navbar when leaving the view
        self.navigationController.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;

        // Un-Color the controls when leaving the view
        [UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = nil;
        [UITableView appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = nil;
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].textColor = nil;
        [UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = nil;
        [self setSegmentedSliderTrackColor:nil];

    }
}

// adds the header to the view
- (void)setupHeader {
    if (![self.specifier propertyForKey:@"headerTitle"]) return;

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.bounds.size.width, 126)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel *subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    [headerLabel setText:[self.specifier propertyForKey:@"headerTitle"]];
    [headerLabel setNumberOfLines:1];
    [headerLabel setFont:[UIFont systemFontOfSize:36]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:headerLabel];
    [headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeBottom multiplier:0.2 constant:0]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:headerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    [subHeaderLabel setText:[self.specifier propertyForKey:@"headerSubtitle"]];
    [subHeaderLabel setNumberOfLines:1];
    [subHeaderLabel setFont:[UIFont systemFontOfSize:17]];
    [subHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [subHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:subHeaderLabel];
    [subHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:subHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:subHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    if (_tintColor) {
        [headerLabel setTextColor:_tintColor];
        [subHeaderLabel setTextColor:_tintColor];
    }

    self.table.tableHeaderView = header;
}

#pragma mark - 3D Touch Handler
// IDEA see if i can subclass 3DTouch rather than implementing it here
- (BOOL)is3DTouchAvailable {
    BOOL isAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isAvailable = (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable);
    }
    return isAvailable;
}

#pragma mark - UITraitEnvironment Protocol

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    // Register for `UIViewControllerPreviewingDelegate` to enable "Peek" and "Pop".
    if ([self is3DTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.table];
    } else if (self.previewingContext) {
        [self unregisterForPreviewingWithContext:self.previewingContext];
        self.previewingContext = nil;
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
// TODO document this
// peek
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {

    PSSpecifier *specifier = [self specifierAtIndexPath:[self.table indexPathForRowAtPoint:location]];
    PSViewController *vc;

    [previewingContext setSourceRect:[self cachedCellForSpecifier:specifier].frame];
    switch (specifier.cellType) {
        case PSButtonCell: {
            vc = [[CSPListController alloc] initWithPlistName:[specifier propertyForKey:@"pushPlist"] inBundle:_bundle];
        } break;

        case PSLinkListCell: {
            NSString *detail = [specifier propertyForKey:PSDetailControllerClassKey];
            if ([detail isEqual:@"CSListItemsController"]) {
                vc = [[CSListItemsController alloc] init];
            } else {
                vc = [[CSListFontsController alloc] init];
            }
        } break;

        case PSLinkCell: {
            if ([specifier propertyForKey:@"url"]) {
                vc = [[CSPBrowserPreviewController alloc] initWithURL:[specifier propertyForKey:@"url"]];
            } else if ([specifier propertyForKey:@"mailto"]) {
                MFMailComposeViewController *mailViewController = [CSPMailComposeManager mailComposeControllerForSpecifier:specifier delegate:self];
                return mailViewController;
            } else if ([[specifier propertyForKey:@"detail"] isEqualToString:@"CSPBackupListViewController"]) {
                vc = [[CSPBackupListViewController alloc] init];
            } else if ([[specifier propertyForKey:@"detail"] isEqualToString:@"CSPChangeLogController"]) {
                vc = [[CSPChangeLogController alloc] init];
            }
        } break;
    }

    [vc setParentController:self];
    [vc setSpecifier:specifier];

    return vc;
}

// pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    if ([viewControllerToCommit isKindOfClass:[MFMailComposeViewController class]]) {
        [self presentViewController:viewControllerToCommit animated:YES completion:nil];
    } else if ([viewControllerToCommit isKindOfClass:[CSPBrowserPreviewController class]]) {
        [self presentViewController:[self safariBrowserForURL:[(CSPBrowserPreviewController *) viewControllerToCommit url]] animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    }
}

#pragma mark PSListController
// dismiss keyboard when pressing return key
- (void)_returnKeyPressed:(id)sender {
    [self.view endEditing:NO];
}

#pragma mark UITableView

// Adjust labels when loading the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
    if (_tintColor) {
        cell.textLabel.textColor = _tintColor;
    }

    if ([cell isKindOfClass:([CSPDeveloperCell class])]) {
        CSPDeveloperCell *devCell = (CSPDeveloperCell *)cell;
        [self avatarForCell:devCell];
        if (_tintColor) {
            [devCell setTintColor:_tintColor];
        }
    }

    return cell;
}

// make sure that the control for the cell is enabled/disabled when the cell is enabled/disabled
- (void)setCellForRowAtIndexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled {
    UITableViewCell *cell = [self tableView:self.table cellForRowAtIndexPath:indexPath];
    if (cell) {
        cell.userInteractionEnabled = enabled;
        cell.textLabel.enabled = enabled;
        cell.detailTextLabel.enabled = enabled;
        cell.clipsToBounds = YES;
        if ([[self fontNames] containsObject:cell.detailTextLabel.text])
            cell.detailTextLabel.font = [UIFont fontWithName:cell.detailTextLabel.text size:cell.detailTextLabel.font.pointSize];

        if ([cell isKindOfClass:[PSControlTableCell class]]) {
            PSControlTableCell *controlCell = (PSControlTableCell *)cell;
            if (controlCell.control) {
                controlCell.control.enabled = enabled;
            }
        }
    }
}

// dismiss keyboard when scrolling begins
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:NO];
}

#pragma mark Preferences

// writes the preferences to disk after setting additionally posts a notification
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSString *key = [specifier propertyForKey:PSKeyNameKey];
    [_settings setObject:value forKey:key];
    [_settings writeToFile:[self preferencePath] atomically:YES];
    // haptic feedback when setting a value, currently overlaps with stock toggles
    // AudioServicesPlaySystemSound(1519);
    [self checkForUpdatesWithSpecifier:specifier animated:YES];

    // if any other specifiers have the same key as the specifier that changed, then we need to update those specifiers aswell as the UI
    for (PSSpecifier *sameKeySpecifier in [self specifiersForKey:[specifier propertyForKey:PSKeyNameKey]]) {
        if ([specifier isEqualToSpecifier:sameKeySpecifier]) continue;
        [self reloadSpecifier:sameKeySpecifier animated:YES];
    }

    NSString *post = [specifier propertyForKey:@"PostNotification"];
    if (post) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)post, NULL, NULL, TRUE);
    }
}

// returns the settings from disk when loading else reads default
- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSString *key = [specifier propertyForKey:PSKeyNameKey];
    id defaultValue = [specifier propertyForKey:PSDefaultValueKey];
    id plistValue = [_settings objectForKey:key];
    if (!plistValue) plistValue = defaultValue;

    [self checkForUpdatesWithSpecifier:specifier animated:NO];

    return plistValue;
}

// TODO create public methods
#pragma mark Extentions
// when setting or reading a value we should check if the changed specifier should alter any other settings or UI
- (void)checkForUpdatesWithSpecifier:(PSSpecifier *)specifier animated:(BOOL)animated {
    NSString *key = [specifier propertyForKey:PSKeyNameKey];
    NSArray *group = [self specifiersInGroup:[self indexPathForSpecifier:specifier].section];

    [self applyChanges:^{
        //if ([_toggleGroups containsObject:key]) {
        if ([specifier propertyForKey:@"isGroupToggle"]) {
            NSPredicate *filter = [self specifierFilterWithOptions:@{ @"keys": @[[specifier propertyForKey:PSKeyNameKey]], @"types": @[@(PSGroupCell)] } excludeOptions:YES];
            [self setSpecifiers:[group filteredArrayUsingPredicate:filter] enabled:[_settings[key] boolValue]];
        }
        // if ([[[self groupSpecifierForGroup:group] propertyForKey:PSIsRadioGroupKey] boolValue]) {
        //     // CSAlertLog(@"Finally a radio group");
        //     NSPredicate *filter = [self specifierFilterWithOptions:@{@"types": @[@(PSSwitchCell)] } excludeOptions:NO];
        //     [self setProperty:@(NO) forSpecifiers:[group filteredArrayUsingPredicate:filter]];
        // }
    } animated:animated];
}

// returns an NSPredicate for filtering specifiers based on keys, types, or identifiers
- (NSPredicate *)specifierFilterWithOptions:(NSDictionary *)options excludeOptions:(BOOL)exclude {

    return [NSPredicate predicateWithBlock:^BOOL (id specifier, NSDictionary *bindings) {
        // filter out all specifiers of the given type or key
        if ([options[@"keys"] containsObject:[specifier propertyForKey:PSKeyNameKey]])
            return !exclude;
        if ([options[@"types"] containsObject:@([specifier cellType])])
            return !exclude;
        return YES;
    }];
}

// returns an array of specifiers in the given group with all the given celltypes filtered out
- (NSArray *)specifiersInGroup:(long long)group excludingTypes:(NSArray *)excluded {
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL (id specifier, NSDictionary *bindings) {
        // filter out all specifiers of the given type
        return ![excluded containsObject:@([specifier cellType])];
    }];
    return [[self specifiersInGroup:group] filteredArrayUsingPredicate:filter];
}

// returns an array of specifiers in the given group with only the given cellTypes
- (NSArray *)specifiersInGroup:(long long)group explicitTypes:(NSArray *)included {
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL (id specifier, NSDictionary *bindings) {
        // filter out all specifiers of the given type
        return [included containsObject:@([specifier cellType])];
    }];
    return [[self specifiersInGroup:group] filteredArrayUsingPredicate:filter];
}

// retuns an array of specifiers with the given key
- (NSArray *)specifiersForKey:(NSString *)key {
    NSMutableArray *specifiers = [NSMutableArray new];
    for (PSSpecifier *specifier in _specifiers) {
        if ([[specifier propertyForKey:PSKeyNameKey] isEqualToString:key]) {
            [specifiers addObject:specifier];
        }
    }
    return [specifiers copy];
}

// sets the height for the specifier when enabled/disabled and updates the cell
- (void)setSpecifier:(PSSpecifier *)specifier enabled:(BOOL)enabled {
    [specifier setProperty:@(enabled ? 44 : 0) forKey:PSTableCellHeightKey];
    [self setCellForRowAtIndexPath:[self indexPathForSpecifier:specifier] enabled:enabled];
}

// calls setSpecifiers: enabled: on an array of specifiers
- (void)setSpecifiers:(NSArray *)specifiers enabled:(BOOL)enabled {
    for (PSSpecifier *specifier in specifiers) {
        [self setSpecifier:specifier enabled:enabled];
    }
}

// returns a block to apply changes either animated or not
- (void)applyChanges:(void (^)(void))changes animated:(BOOL)animated {
    if (animated) {
        [self beginUpdates];
        changes();
        [self endUpdates];
    } else {
        changes();
    }
}

// sets the passed value on all the passed specifiers
- (void)setProperty:(id)property forSpecifiers:(NSArray *)specifiers {
    for (PSSpecifier *specifier in specifiers) {
        [specifier setProperty:property forKey:PSKeyNameKey];
    }
}

// TODO verify this works
// reset a specifier value back to default
- (void)resetSpecifier:(PSSpecifier *)specifier {
    [specifier setProperty:[specifier propertyForKey:PSDefaultValueKey] forKey:PSValueKey];
    [self reloadSpecifier:specifier];
}

// refreshes all of the specifiers in the view and optionaly animates the changes
- (void)refreshAllSpecifiersAnimated:(BOOL)animated {
    [self reload];
    for (PSSpecifier *specifier in _specifiers) {
        [self checkForUpdatesWithSpecifier:specifier animated:NO];
    }
    _refreshQueued = NO;
}

- (void)setBundleValueInSpecifiers {
    for (PSSpecifier *specifier in _specifiers) {
        [specifier setProperty:_bundle.bundlePath forKey:@"bundle"];
    }
}

// refreshes a cell by calling setCellForRowAtIndexPath
- (void)refreshCellWithSpecifier:(PSSpecifier *)specifier {
    [self setCellForRowAtIndexPath:[self indexPathForSpecifier:specifier] enabled:YES];
}

// returns the PSGroupCell specifier for the given group of array of specifiers
- (PSSpecifier *)groupSpecifierForGroup:(NSArray *)group {
    NSPredicate *filter = [self specifierFilterWithOptions:@{@"types": @[@(PSGroupCell)] } excludeOptions:NO];
    return [group filteredArrayUsingPredicate:filter][0];
}

// TODO move to Utility Class and subclass
#pragma mark Utility

// opens the specified url in SFSafariViewController
- (void)openURLInBrowser:(NSString *)url {
    [self presentViewController:[self safariBrowserForURL:url] animated:YES completion:nil];
}

// returns a SFSafariViewController for the given url
- (SFSafariViewController *)safariBrowserForURL:(NSString *)url {
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:NO];
    // using this method for coloring because it supports ios 9 as well
    if (_tintColor) {
        safari.view.tintColor = _tintColor;
    }
    return safari;
}

// TODO move to class and subclass
#pragma mark PSSpecifier Actions
// openInBrowser action
- (void)openInBrowser:(PSSpecifier *)sender {
    [self openURLInBrowser:[sender propertyForKey:@"url"]];
}

// open controller action
- (void)pushToView:(PSSpecifier *)sender {
    _child = [[CSPListController alloc] initWithPlistName:[sender propertyForKey:@"pushPlist"] inBundle:_bundle];
    [_child setSpecifier:sender];
    [self.navigationController pushViewController:_child animated:YES];
}

// email action
- (void)email:(PSSpecifier *)sender {
    MFMailComposeViewController *mailViewController = [CSPMailComposeManager mailComposeControllerForSpecifier:sender delegate:self];
    [self presentViewController:mailViewController animated:YES completion:nil];
}

// respring action
- (void)respring {
    UIAlertAction *cancelAction, *confirmAction;
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"CSPreferences"
                                                          message:@"Are you sure you want to respring?"
                                                   preferredStyle:UIAlertControllerStyleActionSheet];

    cancelAction = [UIAlertAction
                    actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                            handler:nil];

    confirmAction = [UIAlertAction
                     actionWithTitle:@"Respring"
                               style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction *action) {
        pid_t pid;
        int status;
        const char *args[] = {"killall", "SpringBoard", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);
        waitpid(pid, &status, WEXITED);
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark Misc

- (void)avatarForCell:(CSPDeveloperCell *)cell {
    NSString *_imagePath = [NSString stringWithFormat:@"%@/%@_%@.png", [self cacheDirectoryPath], [cell.specifier propertyForKey:@"provider"], [cell.specifier propertyForKey:@"username"]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:_imagePath]) {
        cell.avatar.image = [UIImage imageWithContentsOfFile:_imagePath];
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:cell.avatarURL
                                                                 completionHandler :^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!data) return;

            UIImage *image = [UIImage imageWithData:data];

            if (!image) return;

            dispatch_async(dispatch_get_main_queue(), ^{
                cell.avatar.image = image;
            });

            // save image to cache directory
            NSData *_pngData = UIImagePNGRepresentation(image);
            [_pngData writeToFile:_imagePath atomically:YES];
        }];

        [dataTask resume];
    });
}

- (NSArray *)fontNames {
    if (!_fontNames) {
        NSMutableArray *names = [NSMutableArray new];
        [names addObjectsFromArray:@[@".SFUIDisplay-UltraLight", @".SFUIDisplay-Thin", @".SFUIDisplay-Light", @".SFUIDisplay-Regular", @".SFUIDisplay-Medium", @".SFUIDisplay-Semibold", @".SFUIDisplay-Bold", @".SFUIDisplay-Heavy", @".SFUIDisplay-Black"]];

        for (NSString *familyName in [UIFont familyNames]) {
            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
                [names addObject:fontName];
            }
        }
        _fontNames = [[NSSet setWithArray:names].allObjects sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    return _fontNames;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
