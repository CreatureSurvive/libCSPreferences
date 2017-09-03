# @Author: Dana Buehre <creaturesurvive>
# @Date:   18-08-2017 12:14:22
# @Email:  dbuehre@me.com
# @Filename: Makefile
# @Last modified by:   creaturesurvive
# @Last modified time: 03-09-2017 9:41:01
# @Copyright: Copyright © 2014-2017 CreatureSurvive


ARCHS = armv7 armv7s arm64
TARGET = iphone:clang:latest:latest

GO_EASY_ON_ME = 1
FINALPACKAGE = 0

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libCSPreferences
libCSPreferences_FILES = $(wildcard *.m) $(wildcard *.mm) $(wildcard *.xm)
libCSPreferences_FRAMEWORKS = UIKit AudioToolbox CoreGraphics SafariServices MessageUI
libCSPreferences_PRIVATE_FRAMEWORKS = Preferences
libCSPreferences_CFLAGS = -fobjc-arc

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 Preferences"

SUBPROJECTS += libCSPreferencesHooks
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/library.mk
