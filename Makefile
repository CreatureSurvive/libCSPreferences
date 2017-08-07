ARCHS = armv7 armv7s arm64
GO_EASY_ON_ME=1
TARGET = iphone:clang:10.1:latest
THEOS_DEVICE_IP = 192.168.86.199
THEOS_DEVICE_PORT=22

FINALPACKAGE = 0

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libCSPreferences
libCSPreferences_FILES = $(wildcard *.m) $(wildcard *.mm)
libCSPreferences_FRAMEWORKS = UIKit
libCSPreferences_PRIVATE_FRAMEWORKS = Preferences AudioToolbox
libCSPreferences_LDFLAGS = -Wl,-segalign,4000
libCSPreferences_CFLAGS = -fobjc-arc

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 Preferences"

include $(THEOS_MAKE_PATH)/library.mk
