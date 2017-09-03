/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   09-07-2017 8:46:48
 * @Email:  dbuehre@me.com
 * @Filename: CSPDeveloperCell.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:09
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "CSPDeveloperCell.h"

NSString *const kTwitterAvatar = @"/profile_image?size=original";
NSString *const kGitHubAvatar = @".png";
NSString *const kCSPDevCellID = @"CSPDeveloperCell";

NSString *const CSPDevNameKey = @"devName";
NSString *const CSPDevTitleKey = @"devTitle";
NSString *const CSPDevSubtitleKey = @"devSubtitle";
NSString *const CSPDevURLKey = @"url";

@implementation CSPDeveloperCell {
    int _urlType;
    UILabel *_label;
    NSString *_username;
    NSString *_primaryString;
    NSString *_subString1;
    NSString *_subString2;
}

- (void)setTintColor:(UIColor *)tint {
    _tintColor = tint;
    [self setupLabel];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if ((self = [super initWithStyle:style reuseIdentifier:kCSPDevCellID specifier:specifier])) {

        _primaryString = specifier.properties[CSPDevNameKey];
        _subString1 = specifier.properties[CSPDevTitleKey];
        _subString2 = specifier.properties[CSPDevSubtitleKey];
        _username = specifier.properties[@"username"];
        _urlType = [specifier.properties[@"provider"] intValue];
        self.specifier = specifier;

        [self setupForType];
        [self setupAvatar];
        [self setupLabel];
        [self setupAccessory];
        [self setupConstraints];
        // [self loadImageCellForSpecifier:specifier];
        // self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// setup the constraints for the view
- (void)setupConstraints {
    // avatar constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:16.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10.5-[_avatar]-10.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatar(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar)]];
    // label constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-84-[_label]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_label]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
}

//TODO use an array here
// setup the label
- (void)setupLabel {
    NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@", _primaryString, _subString1, _subString2];

    if (!content.length) return;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:[content rangeOfString:_primaryString]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:[content rangeOfString:_subString1]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:[content rangeOfString:_subString2]];
    if (_tintColor) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:_tintColor range:[content rangeOfString:_primaryString]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[_tintColor colorWithAlphaComponent:0.75] range:NSMakeRange(_primaryString.length, content.length - _primaryString.length)];
    }
    if (!_label) {
        _label = [UILabel new];
        [_label setNumberOfLines:0];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_label];
    }
    [_label setAttributedText:[attributedString copy]];
}

// setup the image view for the avatar
- (void)setupAvatar {
    UIImage *avatar = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Library/PreferenceBundles/motuumLS.bundle/%@.png", self.specifier.properties[@"imageName"]]];
    _avatar = [[UIImageView alloc] initWithImage:avatar];
    _avatar.translatesAutoresizingMaskIntoConstraints = NO;
    _avatar.layer.cornerRadius = 30;
    _avatar.clipsToBounds = YES;
    [self addSubview:_avatar];
}

// sets the url and urlType based on the specifier
- (void)setupForType {
    NSString *URL, *baseURL;
    if (_username) {
        switch (_urlType) {
            case 0:
                baseURL = [NSString stringWithFormat:@"https://github.com/%@", _username];
                URL = [baseURL stringByAppendingString:kGitHubAvatar];
                break;
            case 1:
                baseURL = [NSString stringWithFormat:@"https://twitter.com/%@", _username];
                URL = [baseURL stringByAppendingString:kTwitterAvatar];
                break;
            default:
                baseURL = @"http://en.wikipedia.org/wiki/Special:Random";
                URL = [NSString stringWithFormat:@"http://api.adorable.io/avatar/180/%@", _username];
                break;
        }
    }
    [self.specifier setProperty:baseURL forKey:@"url"];
    _avatarURL = [NSURL URLWithString:URL];
}

// sets the accesory view to github or twitter icon
- (void)setupAccessory {
    UIImage *glyph = _urlType == 0 ? [self githubBrandingWithSize:CGSizeMake(16.0f, 16.0f)] : _urlType == 1 ? [self twitterBrandingWithSize:CGSizeMake(16.0f, 16.0f)] : nil;
    if (!glyph) return;
    UIImageView *glyphView = [[UIImageView alloc] initWithImage:glyph];
    glyphView.frame = CGRectMake(-8, 0, glyph.size.width, glyph.size.height);
    self.accessoryView = glyphView;
}

// TODO this needs to move to UIImage+CSPreferences
- (UIImage *)twitterBrandingWithSize:(CGSize)size {
    static UIImage *_twitterBranding = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        UIColor *twitterColor = [UIColor colorWithRed:0.114 green:0.631 blue:0.949 alpha:1];

        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0.31608 * size.width, 1.00000 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.89791 * size.width, 0.28157 * size.height) controlPoint1:CGPointMake(0.69219 * size.width, 1.00000 * size.height) controlPoint2:CGPointMake(0.89791 * size.width, 0.61524 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.89732 * size.width, 0.24893 * size.height) controlPoint1:CGPointMake(0.89791 * size.width, 0.27064 * size.height) controlPoint2:CGPointMake(0.89791 * size.width, 0.25976 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.89803 * size.width, 0.24830 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.99840 * size.width, 0.11995 * size.height) controlPoint1:CGPointMake(0.93729 * size.width, 0.21307 * size.height) controlPoint2:CGPointMake(0.97126 * size.width, 0.16964 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(1.00000 * size.width, 0.11787 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.88373 * size.width, 0.15769 * size.height) controlPoint1:CGPointMake(0.96305 * size.width, 0.13818 * size.height) controlPoint2:CGPointMake(0.92387 * size.width, 0.15160 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.88217 * size.width, 0.15775 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.97164 * size.width, 0.01886 * size.height) controlPoint1:CGPointMake(0.92458 * size.width, 0.12629 * size.height) controlPoint2:CGPointMake(0.95635 * size.width, 0.07696 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.97373 * size.width, 0.01688 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.84086 * size.width, 0.07985 * size.height) controlPoint1:CGPointMake(0.93275 * size.width, 0.04728 * size.height) controlPoint2:CGPointMake(0.88778 * size.width, 0.06859 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.84253 * size.width, 0.08037 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.55324 * size.width, 0.06790 * size.height) controlPoint1:CGPointMake(0.76543 * size.width, -0.02171 * size.height) controlPoint2:CGPointMake(0.63592 * size.width, -0.02730 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.49340 * size.width, 0.30959 * size.height) controlPoint1:CGPointMake(0.49976 * size.width, 0.12948 * size.height) controlPoint2:CGPointMake(0.47695 * size.width, 0.22161 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.49214 * size.width, 0.30980 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.07134 * size.width, 0.04506 * size.height) controlPoint1:CGPointMake(0.32783 * size.width, 0.29916 * size.height) controlPoint2:CGPointMake(0.17489 * size.width, 0.20294 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.07173 * size.width, 0.04665 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.13452 * size.width, 0.38247 * size.height) controlPoint1:CGPointMake(0.01799 * size.width, 0.16158 * size.height) controlPoint2:CGPointMake(0.04542 * size.width, 0.30826 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.13424 * size.width, 0.38309 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.04293 * size.width, 0.35182 * size.height) controlPoint1:CGPointMake(0.10223 * size.width, 0.38171 * size.height) controlPoint2:CGPointMake(0.07094 * size.width, 0.37099 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.04250 * size.width, 0.35472 * size.height) controlPoint1:CGPointMake(0.04250 * size.width, 0.35256 * size.height) controlPoint2:CGPointMake(0.04250 * size.width, 0.35364 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.04250 * size.width, 0.35466 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.20803 * size.width, 0.60260 * size.height) controlPoint1:CGPointMake(0.04250 * size.width, 0.47557 * size.height) controlPoint2:CGPointMake(0.11190 * size.width, 0.57953 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.20568 * size.width, 0.60253 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.11389 * size.width, 0.60649 * size.height) controlPoint1:CGPointMake(0.17572 * size.width, 0.61245 * size.height) controlPoint2:CGPointMake(0.14433 * size.width, 0.61380 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.11441 * size.width, 0.60730 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.30555 * size.width, 0.78193 * size.height) controlPoint1:CGPointMake(0.14142 * size.width, 0.70991 * size.height) controlPoint2:CGPointMake(0.21818 * size.width, 0.78004 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.30435 * size.width, 0.78282 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.05173 * size.width, 0.89022 * size.height) controlPoint1:CGPointMake(0.23220 * size.width, 0.85242 * size.height) controlPoint2:CGPointMake(0.14328 * size.width, 0.89022 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.05211 * size.width, 0.89022 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.00138 * size.width, 0.88639 * size.height) controlPoint1:CGPointMake(0.03515 * size.width, 0.89022 * size.height) controlPoint2:CGPointMake(0.01821 * size.width, 0.88894 * size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.00000 * size.width, 0.88448 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.31531 * size.width, 0.99980 * size.height) controlPoint1:CGPointMake(0.09386 * size.width, 0.95975 * size.height) controlPoint2:CGPointMake(0.20339 * size.width, 0.99980 * size.height)];
        [twitterColor setFill];
        [bezierPath fill];

        _twitterBranding = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });

    return _twitterBranding;
}

// TODO this needs to move to UIImage+CSPreferences
- (UIImage *)githubBrandingWithSize:(CGSize)size {
    static UIImage *_githubBranding = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        UIColor *githubColor = [UIColor colorWithRed:0.085 green:0.084 blue:0.078 alpha:1];

        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0.49995 * size.width, -0.00000 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.00000 * size.width, 0.51267 * size.height) controlPoint1:CGPointMake(0.22386 * size.width, -0.00000 * size.height) controlPoint2:CGPointMake(0.00000 * size.width, 0.22952 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.34194 * size.width, 0.99912 * size.height) controlPoint1:CGPointMake(0.00000 * size.width, 0.73917 * size.height) controlPoint2:CGPointMake(0.14325 * size.width, 0.93130 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.37607 * size.width, 0.97439 * size.height) controlPoint1:CGPointMake(0.36695 * size.width, 1.00381 * size.height) controlPoint2:CGPointMake(0.37607 * size.width, 0.98798 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.37540 * size.width, 0.88721 * size.height) controlPoint1:CGPointMake(0.37607 * size.width, 0.96224 * size.height) controlPoint2:CGPointMake(0.37564 * size.width, 0.92998 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.20697 * size.width, 0.81848 * size.height) controlPoint1:CGPointMake(0.23632 * size.width, 0.91818 * size.height) controlPoint2:CGPointMake(0.20697 * size.width, 0.81848 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.15145 * size.width, 0.74351 * size.height) controlPoint1:CGPointMake(0.18423 * size.width, 0.75928 * size.height) controlPoint2:CGPointMake(0.15145 * size.width, 0.74351 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.15489 * size.width, 0.71232 * size.height) controlPoint1:CGPointMake(0.10605 * size.width, 0.71169 * size.height) controlPoint2:CGPointMake(0.15489 * size.width, 0.71232 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.23147 * size.width, 0.76516 * size.height) controlPoint1:CGPointMake(0.20507 * size.width, 0.71597 * size.height) controlPoint2:CGPointMake(0.23147 * size.width, 0.76516 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.37699 * size.width, 0.80778 * size.height) controlPoint1:CGPointMake(0.27607 * size.width, 0.84350 * size.height) controlPoint2:CGPointMake(0.34851 * size.width, 0.82087 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.40873 * size.width, 0.73923 * size.height) controlPoint1:CGPointMake(0.38153 * size.width, 0.77464 * size.height) controlPoint2:CGPointMake(0.39443 * size.width, 0.75204 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.18098 * size.width, 0.48586 * size.height) controlPoint1:CGPointMake(0.29771 * size.width, 0.72630 * size.height) controlPoint2:CGPointMake(0.18098 * size.width, 0.68230 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.23245 * size.width, 0.34829 * size.height) controlPoint1:CGPointMake(0.18098 * size.width, 0.42990 * size.height) controlPoint2:CGPointMake(0.20047 * size.width, 0.38414 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.23733 * size.width, 0.21262 * size.height) controlPoint1:CGPointMake(0.22729 * size.width, 0.33533 * size.height) controlPoint2:CGPointMake(0.21014 * size.width, 0.28321 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.37484 * size.width, 0.26518 * size.height) controlPoint1:CGPointMake(0.23733 * size.width, 0.21262 * size.height) controlPoint2:CGPointMake(0.27932 * size.width, 0.19884 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.50002 * size.width, 0.24793 * size.height) controlPoint1:CGPointMake(0.41472 * size.width, 0.25382 * size.height) controlPoint2:CGPointMake(0.45750 * size.width, 0.24812 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.62519 * size.width, 0.26518 * size.height) controlPoint1:CGPointMake(0.54247 * size.width, 0.24812 * size.height) controlPoint2:CGPointMake(0.58525 * size.width, 0.25382 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.76255 * size.width, 0.21262 * size.height) controlPoint1:CGPointMake(0.72065 * size.width, 0.19884 * size.height) controlPoint2:CGPointMake(0.76255 * size.width, 0.21262 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.76752 * size.width, 0.34829 * size.height) controlPoint1:CGPointMake(0.78983 * size.width, 0.28321 * size.height) controlPoint2:CGPointMake(0.77268 * size.width, 0.33533 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.81893 * size.width, 0.48586 * size.height) controlPoint1:CGPointMake(0.79956 * size.width, 0.38414 * size.height) controlPoint2:CGPointMake(0.81893 * size.width, 0.42990 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.59063 * size.width, 0.73882 * size.height) controlPoint1:CGPointMake(0.81893 * size.width, 0.68280 * size.height) controlPoint2:CGPointMake(0.70202 * size.width, 0.72614 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.62457 * size.width, 0.83377 * size.height) controlPoint1:CGPointMake(0.60858 * size.width, 0.75465 * size.height) controlPoint2:CGPointMake(0.62457 * size.width, 0.78594 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.62396 * size.width, 0.97439 * size.height) controlPoint1:CGPointMake(0.62457 * size.width, 0.90229 * size.height) controlPoint2:CGPointMake(0.62396 * size.width, 0.95758 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.65834 * size.width, 0.99906 * size.height) controlPoint1:CGPointMake(0.62396 * size.width, 0.98811 * size.height) controlPoint2:CGPointMake(0.63295 * size.width, 1.00406 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(1.00000 * size.width, 0.51267 * size.height) controlPoint1:CGPointMake(0.85687 * size.width, 0.93111 * size.height) controlPoint2:CGPointMake(1.00000 * size.width, 0.73911 * size.height)];
        [bezierPath addCurveToPoint:CGPointMake(0.49995 * size.width, -0.00000 * size.height) controlPoint1:CGPointMake(1.00000 * size.width, 0.22952 * size.height) controlPoint2:CGPointMake(0.77611 * size.width, -0.00000 * size.height)];
        [bezierPath closePath];
        bezierPath.usesEvenOddFillRule = YES;
        [githubColor setFill];
        [bezierPath fill];

        _githubBranding = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });

    return _githubBranding;
}

// TODO this needs to move to the view controller
- (void)loadImageCellForSpecifier:(PSSpecifier *)specifier {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:_avatarURL
                                                                 completionHandler :^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!data) return;

            UIImage *image = [UIImage imageWithData:data];

            if (!image) return;

            dispatch_async(dispatch_get_main_queue(), ^{
                _avatar.image = image;
            });
        }];

        [dataTask resume];
    });
}

@end
