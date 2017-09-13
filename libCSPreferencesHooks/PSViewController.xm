/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   01-09-2017 11:00:18
 * @Email:  dbuehre@me.com
 * @Filename: PSViewController.xm
 * @Last modified by:   creaturesurvive
 * @Last modified time: 11-09-2017 6:16:46
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "../UIColor+ColorFromHex.h"
#import <Preferences/PSSpecifier.h>
#import <SafariServices/SafariServices.h>
#include <spawn.h>

@interface PSViewController : UIViewController
@property (nonatomic, retain) UIColor *tintColor;
- (void)setTintEnabled:(BOOL)enabled;
- (PSSpecifier *)specifier;
- (PSViewController *)parentController;
- (void)respring;
- (void)copyTweakList;
- (void)postTweakList:(NSString *)list;
- (void)postToGhostBin:(NSString *)body expiration:(NSString *)expire completion:(void (^)(NSURL *, NSError *))completion;
@end

@interface PSListController : PSViewController
@property (nonatomic, retain) NSBundle *bundle;
@end


%hook PSViewController
%property(nonatomic, retain) UIColor *tintColor;

- (void)viewWillAppear:(BOOL)animated {
    [self setTintEnabled:YES];
    %orig(animated);
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig(animated);
    [self setTintEnabled:NO];
}

// sets the tint colors for the view
%new
- (void)setTintEnabled: (BOOL)enabled {

    if ([self.specifier propertyForKey:@"tintColor"]) {
        self.tintColor = [UIColor colorFromHexString:[self.specifier propertyForKey:@"tintColor"]];
    } else if ([[self parentController] respondsToSelector:@selector(bundle)]) {
        NSBundle *bundle = [(PSListController *)[self parentController] bundle];

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

%new
- (void)respring {
    UIAlertAction *cancelAction, *confirmAction;
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to respring?" preferredStyle:UIAlertControllerStyleActionSheet];

    cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    // for some reason FBSystemService is not working here, so we'll use posix_spawn instead
    confirmAction = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
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

%new
- (void)copyTweakList {
    // create the tweak list and filtr a few thing out
    #pragma GCC diagnostic push
    #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    system("dpkg --get-selections | grep -v 'deinstall' | grep -v 'gsc' >/var/tmp/com.creaturecoding.cspreferences.tweaklist.txt");
    #pragma GCC diagnostic pop

    NSString *list = [NSString stringWithContentsOfFile:@"/var/tmp/com.creaturecoding.cspreferences.tweaklist.txt" encoding:NSUTF8StringEncoding error:nil];

    UIAlertController *copySelectionAlert;
    UIAlertAction *copyURLAction, *copyListAction, *cancelSelectionAction;

    copySelectionAlert = [UIAlertController alertControllerWithTitle:nil
                                                             message:@"What would you like to do\n\n• List - will copy your tweak list to your clipboard.\n\n• Link - will upload your tweak list to ghostbin and copy the link to your clipboard, this is convinient if you would like to share your tweak list online"
                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    cancelSelectionAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    copyURLAction = [UIAlertAction actionWithTitle:@"link (ghostbin)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self postTweakList:list];
    }];

    copyListAction = [UIAlertAction actionWithTitle:@"tweak list" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIPasteboard generalPasteboard] setString:list];
    }];

    [copySelectionAlert addAction:cancelSelectionAction];
    [copySelectionAlert addAction:copyListAction];
    [copySelectionAlert addAction:copyURLAction];
    [self presentViewController:copySelectionAlert animated:YES completion:nil];
}

%new
- (void)postTweakList: (NSString *)list {
    __block UIAlertController *alertController;
    __block UIAlertAction *cancelAction, *okAction, *errorAction;

    [self postToGhostBin:list expiration:@"15d" completion:^(NSURL *responce, NSError *error) {

        if (!error) {
            [[UIPasteboard generalPasteboard] setString:responce.description];
            alertController = [UIAlertController alertControllerWithTitle:nil
                                                                  message:@"Your Tweak List has been posted to GhostBin and the link copied to your clipboard!\n\nWould you like to open the link now?"
                                                           preferredStyle:UIAlertControllerStyleActionSheet];

            cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];

            okAction = [UIAlertAction actionWithTitle:@"open link (browser)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:responce entersReaderIfAvailable:NO];
                safari.view.tintColor = self.tintColor;
                [self presentViewController:safari animated:YES completion:nil];
            }];

            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
        } else {
            [[UIPasteboard generalPasteboard] setString:list];
            alertController = [UIAlertController alertControllerWithTitle:@"motuumLS"
                                                                  message:[NSString stringWithFormat:@"there was an error uploading your tweak list to GhostBin, your tweak list has still been copied to your clipboard \n\n\n\n%@", error]
                                                           preferredStyle:UIAlertControllerStyleAlert];
            errorAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil ];
            [alertController addAction:errorAction];
        }

        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

%new
- (void)postToGhostBin: (NSString *)body expiration: (NSString *)expire completion: (void (^)(NSURL *, NSError *))completion {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    // post data
    NSString *postData = [NSString stringWithFormat:@"text=%@&expire=%@&lang=%@", body, expire, @"text"];

    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[NSURL URLWithString:@"https://ghostbin.com/paste/new"]];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!error) {
            NSURL *url = response.URL;
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode > 199 && statusCode < 300) {
                completion(url, nil);
            } else {
                completion(nil, error);
            }
        } else {
            completion(nil, error);
        }
    }];
    [postDataTask resume];
}

// setup actions for the preview
- (NSArray<id<UIPreviewActionItem> > *)previewActionItems {

    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Open" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [self.parentController.navigationController pushViewController:self animated:YES];
    }];

    NSArray *actions = @[action1];

    return actions;
}

%end
