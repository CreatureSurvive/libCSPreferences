/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   04-09-2017 4:28:51
 * @Email:  dbuehre@me.com
 * @Filename: CSPDatePickerCell.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 04-09-2017 4:36:37
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


 #import "CSPDatePickerCell.h"

NSString *const kCSPDatePickerID = @"CSPDatePickerCell";

@implementation CSPDatePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if ((self = [super initWithStyle:style reuseIdentifier:kCSPDatePickerID specifier:specifier])) {

        self.textLabel.text = @"dateCell";
        self.specifier = specifier;

        // [self setupConstraints];
    }
    return self;
}

// setup the constraints for the view
// - (void)setupConstraints {
//     // avatar constraints
//     [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:16.0]];
//     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10.5-[_avatar]-10.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar)]];
//     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatar(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar)]];
//     // label constraints
//     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-84-[_label]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
//     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_label]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
// }

@end
