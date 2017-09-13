/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   12-09-2017 11:50:45
 * @Email:  dbuehre@me.com
 * @Filename: CSPColorPreviewController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 12-09-2017 12:28:36
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#include "CSPColorPreviewController.h"
#include "CSPListController.h"

@implementation CSPColorPreviewController {
    UIColor *_color;
}

- (id)initWithColor:(UIColor *)color {
    if ((self = [super init])) {
        _color = color;
        self.view.backgroundColor = color;
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:self.view.frame];
        infoLabel.text = [UIColor informationStringForColor:color];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.numberOfLines = 0;
        infoLabel.textColor = [UIColor isColorLight:color] ? [UIColor darkTextColor] : [UIColor lightTextColor];
        [self.view addSubview:infoLabel];
    }
    return self;
}

- (NSArray<id<UIPreviewActionItem> > *)previewActionItems {

    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Open" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [self.parentController pushController:self animate:YES];
    }];

    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Copy Hex" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [[UIPasteboard generalPasteboard] setString:[UIColor hexStringFromColor:_color]];
    }];

    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Set From Clipboard" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [(CSPListController *) self.parentController setPreferenceValue:[UIPasteboard generalPasteboard].string specifier:self.specifier];
    }];

    NSArray *actions = @[action1, action2, action3];

    return actions;
}

@end
