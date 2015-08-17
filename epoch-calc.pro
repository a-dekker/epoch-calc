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
    rpm/epoch-calc.yaml \
    harbour-epoch-calc.desktop \
    harbour-epoch-calc.png \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/Help.qml \
    qml/pages/TimePickerSeconds.qml \
    qml/pages/TimeDialog.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
# TRANSLATIONS += translations/epoch-calc-de.ts

HEADERS += \

