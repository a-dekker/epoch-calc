import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage
    property bool largeScreen: screen.width >= 1080

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            SectionHeader {
                text: qsTr("Info")
                visible: isPortrait || (largeScreen && screen.width > 1080)
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || (largeScreen && screen.width > 1080) || screen.width < 1080
            }
            Label {
                text: "epoch-calc"
                font.pixelSize: largeScreen ? Theme.fontSizeHuge : Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: largeScreen ? 250 : 80
                height: width
                radius: 200
                anchors.horizontalCenter: parent.horizontalCenter
                NumberAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 5000
                    loops: 1
                }
                Image {
                    source: largeScreen ? "/usr/share/icons/hicolor/256x256/apps/harbour-epoch-calc.png" : "/usr/share/icons/hicolor/86x86/apps/harbour-epoch-calc.png"
                }
            }
            Label {
                font.pixelSize: largeScreen ? Theme.fontSizeLarge : Theme.fontSizeMedium
                text: qsTr("Version") + " " + version
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: "Assistant for calculating Unix time"
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
            }
            SectionHeader {
                text: qsTr("Author")
                visible: isPortrait || (largeScreen && screen.width > 1080)
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || (largeScreen && screen.width > 1080) || screen.width < 1080
            }
            Label {
                text: "© Arno Dekker 2014-2017"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
