# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-epoch-calc

CONFIG += sailfishapp

SOURCES += src/epoch-calc.cpp

OTHER_FILES += qml/epoch-calc.qml \
    qml/cover/CoverPage.qml \
    rpm/epoch-calc.changes.in \
    rpm/epoch-calc.spec \
    harbour-epoch-calc.desktop \
    qml/images/coverbg.png \
    qml/images/timepicker.png \
    qml/images/TimePickerSeconds.png \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/Help.qml \
    qml/pages/TimePickerSeconds.qml \
    qml/pages/TimeDialog.qml

isEmpty(VERSION) {
    VERSION = $$system( egrep "^Version:\|^Release:" rpm/epoch-calc.spec |tr -d "[A-Z][a-z]: " | tr "\\\n" "." | sed "s/\.$//g"| tr -d "[:space:]")
    message("VERSION is unset, assuming $$VERSION")
}
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

icon86.files += icons/86x86/harbour-epoch-calc.png
icon86.path = /usr/share/icons/hicolor/86x86/apps

icon108.files += icons/108x108/harbour-epoch-calc.png
icon108.path = /usr/share/icons/hicolor/108x108/apps

icon128.files += icons/128x128/harbour-epoch-calc.png
icon128.path = /usr/share/icons/hicolor/128x128/apps

icon172.files += icons/172x172/harbour-epoch-calc.png
icon172.path = /usr/share/icons/hicolor/172x172/apps

icon256.files += icons/256x256/harbour-epoch-calc.png
icon256.path = /usr/share/icons/hicolor/256x256/apps

INSTALLS += icon86 icon108 icon128 icon172 icon256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
# TRANSLATIONS += translations/epoch-calc-de.ts

HEADERS += \
