/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   08-07-2017 12:03:11
 * @Email:  dbuehre@me.com
 * @Filename: CSPBrowserPreviewController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 09-07-2017 9:36:02
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */

#import "CSPBrowserPreviewController.h"

@implementation CSPBrowserPreviewController {
    NSString *_url;
}

// initialize the controller and set the url
- (id)initWithURL:(NSString *)url {
    if ((self = [super init]) != nil) {
        _url = url;
    }

    return self;
}

// load the webview for the preview
- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];

    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];
}

- (NSString *)url {
    return _url;
}

// setup actions for the preview
- (NSArray<id<UIPreviewActionItem> > *)previewActionItems {

    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Open" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [(CSPListController *) self.parentController openURLInBrowser:_url];
    }];

    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Open in Safari" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }];

    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Copy URL" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController) {
        [[UIPasteboard generalPasteboard] setURL:[NSURL URLWithString:_url]];
    }];

    NSArray *actions = @[action1, action2, action3];

    return actions;
}

@end
