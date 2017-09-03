/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   09-07-2017 8:49:24
 * @Email:  dbuehre@me.com
 * @Filename: CSPDeveloperCell.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 03-09-2017 9:39:05
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "CSPCommon.h"

@interface CSPDeveloperCell : PSTableCell

@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIColor *tintColor;
@end
