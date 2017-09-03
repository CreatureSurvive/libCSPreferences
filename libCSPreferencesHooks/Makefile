# @Author: Dana Buehre <creaturesurvive>
# @Date:   01-09-2017 12:03:28
# @Email:  dbuehre@me.com
# @Filename: Makefile
# @Last modified by:   creaturesurvive
# @Last modified time: 01-09-2017 1:19:30
# @Copyright: Copyright © 2014-2017 CreatureSurvive

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = libCSPreferencesHooks
libCSPreferencesHooks_FILES = $(wildcard *.xm)
# libCSPreferencesHooks_FILES = PSViewController.xm
libCSPreferencesHooks_FRAMEWORKS = UIKit
libCSPreferencesHooks_PRIVATE_FRAMEWORKS = Preferences
libCSPreferencesHooks_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 Preferences"
