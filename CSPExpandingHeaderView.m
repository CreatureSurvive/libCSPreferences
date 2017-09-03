/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   02-07-2017 5:12:52
 * @Email:  dbuehre@me.com
 * @Filename: CSPExpandingHeaderView.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:27
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "CSPExpandingHeaderView.h"

@interface CSPExpandingHeaderView ()

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger totalRows;
@property (nonatomic, strong) UIButton *headerButton;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isCollapsed;
@property (nonatomic, retain) UIColor *headerTextColor;

@end

@implementation CSPExpandingHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame textColor:(UIColor *)color {

    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.frame = frame;
        self.headerTextColor = color ? color : [UIColor darkTextColor];
        [self addHeaderButton];
    }

    return self;
}

- (void)addHeaderButton {

    _headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headerButton.frame = self.bounds;
    self.headerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.headerButton setTitleColor:self.headerTextColor forState:UIControlStateNormal];
    [self.headerButton addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:self.headerButton];
}

- (void)headerButtonAction:(UIButton *)headerButton {

    self.isCollapsed = !self.isCollapsed;
    [self setHeaderText];

    if ([self.delegate respondsToSelector:@selector(didTapHeader:)]) {
        [self.delegate didTapHeader:self];
    }
}

- (void)updateWithTitle:(NSString *)title isCollapsed:(BOOL)isCollapsed totalRows:(NSInteger)row andSection:(NSInteger)section {

    self.title = title;
    self.isCollapsed = isCollapsed;
    self.section = section;
    self.totalRows = row;

    [self setHeaderText];
}

- (void)setHeaderText {
    NSString *plusOrMinus = (self.isCollapsed) ? @" ▶︎  " : @" ▼  ";
    [UIView transitionWithView:self duration:0.15f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.headerButton setTitle:[plusOrMinus stringByAppendingString:self.title] forState:UIControlStateNormal];
    } completion:nil];
}

@end
