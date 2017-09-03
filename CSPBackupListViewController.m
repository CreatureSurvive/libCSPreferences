/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   29-08-2017 12:57:19
 * @Email:  dbuehre@me.com
 * @Filename: CSPBackupListViewController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 01-09-2017 8:44:58
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "CSPBackupListViewController.h"

@implementation CSPBackupListViewController {
    NSString *_backupDirectory;
    NSString *_bundleID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _backupDirectory = nil;
}

- (NSString *)backupDirectory {
    if (!_backupDirectory) {
        _backupDirectory = [NSString stringWithFormat:@"/User/Documents/CSPreferences/Backups/%@", [self bundleID]];
    }
    return _backupDirectory;
}

- (NSString *)bundleID {
    if (!_bundleID) {
        _bundleID = [(PSListController *)[self parentController] bundle].bundleIdentifier;
    }
    return _bundleID;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *specifiers = [NSMutableArray new];

        NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self backupDirectory] error:nil];
        NSArray *plistFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.plist'"]];

        PSSpecifier *newBackupGroup = [PSSpecifier preferenceSpecifierNamed:@"Create New Backup" target:self set:NULL get:NULL detail:Nil cell:PSGroupCell edit:Nil];
        PSSpecifier *createBackupSpecifier = [PSSpecifier preferenceSpecifierNamed:@"New Backup" target:self set:NULL get:NULL detail:Nil cell:PSButtonCell edit:Nil];
        PSSpecifier *existingBackupGroup = [PSSpecifier preferenceSpecifierNamed:@"Existing Backups" target:self set:NULL get:NULL detail:Nil cell:PSGroupCell edit:Nil];

        createBackupSpecifier->action = @selector(createBackup);
        [createBackupSpecifier setProperty:@(YES) forKey:@"lockEditing"];
        [specifiers addObject:newBackupGroup];
        [specifiers addObject:createBackupSpecifier];
        [specifiers addObject:existingBackupGroup];

        if (plistFiles && [plistFiles count] >= 1) {

            for (NSURL *fileURL in plistFiles) {
                NSString *fileName = [[fileURL lastPathComponent] stringByDeletingPathExtension];
                PSSpecifier *newSpecifier = [PSSpecifier preferenceSpecifierNamed:fileName target:self set:NULL get:NULL detail:Nil cell:PSLinkCell edit:Nil];

                newSpecifier->action = @selector(tappedAction:);
                [newSpecifier setProperty:NSStringFromSelector(@selector(removeSpecifier:)) forKey:PSDeletionActionKey];
                [specifiers addObject:newSpecifier];
            }
        } else {
            [specifiers addObject:[self returnZeroCustomEntries]];
        }
        _specifiers = [NSArray arrayWithArray:specifiers];
    }

    return _specifiers;
}

- (void)createBackup {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Create New Backup:" message:@"Backup Name" preferredStyle:UIAlertControllerStyleAlert];


    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeDefault;
        // get the datestring for our file name
        NSString *date = [[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle]
                          stringByReplacingOccurrencesOfString:@"/"
                                                    withString:@"-"];
        textField.text = [NSString stringWithFormat:@"Backup (%@)", date];
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Create Backup" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *from = [NSString stringWithFormat:@"User/Library/Preferences/%@.plist", [self bundleID]];
        NSString *to = [NSString stringWithFormat:@"%@/%@.plist", [self backupDirectory], alertController.textFields[0].text];
        // CSAlertLog(@"from:%@ | to:%@", from, to);
        [self copyFileAtPath:from toPath:to replaceExisting:YES];
        [self reloadSpecifiers];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (PSSpecifier *)returnZeroCustomEntries {
    PSSpecifier *noEntrySpecifier = [PSSpecifier preferenceSpecifierNamed:@"No Backups Found" target:self set:NULL get:NULL detail:Nil cell:PSStaticTextCell edit:Nil];
    return noEntrySpecifier;
}

- (void)removeSpecifier:(PSSpecifier *)specifier {
    [self removeFileAtPath:[NSString stringWithFormat:@"%@/%@.plist", [self backupDirectory], specifier.name]];
}

- (void)openFileAtPath:(NSString *)path {
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    UIDocumentInteractionController *interactionController;

    interactionController = [UIDocumentInteractionController interactionControllerWithURL:pathURL];
    [interactionController setDelegate:self];
    //    [interactionController presentOpenInMenuFromRect:CGRectMake(0, 0, 10, 10) inView:self.view animated:YES];
    [interactionController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
}

- (void)removeFileAtPath:(NSString *)filePath {
    NSError *error = nil;

    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        CSDebug(@"[Error] %@ (%@)", error, filePath);
    }
    [self reloadSpecifiers];
}

- (void)copyFileAtPath:(NSString *)fromPath toPath:(NSString *)toPath replaceExisting:(BOOL)destructive {
    NSError *error = nil;

    if (destructive) {
        [self removeFileAtPath:toPath];
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:[toPath stringByDeletingLastPathComponent] isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[toPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    if ([[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&error]) {
        CSDebug(@"[Error] %@ (copyFrom:%@ | copyTo:%@)", error, fromPath, toPath);
    }
}

- (void)renameFilePopup:(NSString *)fileName {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rename File:" message:fileName preferredStyle:UIAlertControllerStyleAlert];


    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.text = fileName;
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@/%@.plist", [self backupDirectory], fileName]
                                                toPath:[NSString stringWithFormat:@"%@/%@.plist", [self backupDirectory], alertController.textFields[0].text]
                                                 error:&error];
        [self reloadSpecifiers];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tappedAction:(PSSpecifier *)specifier {
    NSString *fileName = specifier.name;
    UIAlertController *alertController;
    UIAlertAction *confirmAction, *cancelAction, *openInAction, *renameAction, *deleteAction;


    alertController = [UIAlertController alertControllerWithTitle:nil
                                                          message:[NSString stringWithFormat:@"Are you sure you want to restore to:\n\n'%@'\n\nThis will overwrite your current settings\n(All changes will take place immediatly)", fileName]
                                                   preferredStyle:UIAlertControllerStyleActionSheet];

    cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    openInAction = [UIAlertAction actionWithTitle:@"Open In App" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openFileAtPath:[NSString stringWithFormat:@"%@/%@.plist", [self backupDirectory], fileName]];
    }];

    renameAction = [UIAlertAction actionWithTitle:@"Rename Backup" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self renameFilePopup:fileName];
    }];

    deleteAction = [UIAlertAction actionWithTitle:@"Delete Backup" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self removeFileAtPath:[NSString stringWithFormat:@"%@/%@.plist", [self backupDirectory], fileName]];
    }];

    confirmAction = [UIAlertAction actionWithTitle:@"Yes, Restore Now" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.plist", [self backupDirectory], fileName];
        [self copyFileAtPath:filePath toPath:[NSString stringWithFormat:@"User/Library/Preferences/%@.plist", [self bundleID]] replaceExisting:YES];

        NSDictionary *restoreValues = [NSDictionary dictionaryWithContentsOfFile:filePath];
        for (NSString *key in restoreValues.allKeys) {
            CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)restoreValues[key], (__bridge CFStringRef)[self bundleID]);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCSPReloadSettings" object:nil];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("kMLSRestorePrefs"), NULL, NULL, TRUE);
    }];
    [alertController addAction:openInAction];
    [alertController addAction:renameAction];
    [alertController addAction:deleteAction];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// setup actions for the preview
- (NSArray<id<UIPreviewActionItem> > *)previewActionItems {

    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Open" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [self.parentController.navigationController pushViewController:self animated:YES];
    }];

    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Create New Backup" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [self.parentController.navigationController pushViewController:self animated:YES];
        [self createBackup];
    }];

    NSArray *actions = @[action1, action2];

    return actions;
}

@end
