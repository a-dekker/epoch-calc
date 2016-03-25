import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: helpPage
    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted
    property bool largeScreen: Screen.sizeCategory === Screen.Large ||
                               Screen.sizeCategory === Screen.ExtraLarge
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
                title: "Info"
            }
            Label {
                width: col.width - Theme.paddingLarge * 2
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                text: "<html><h2>epoch-calc</h2> helps you to convert the Unix time to human readable format and vice versa.<br><br> \
<b><u>Unix time:</u></b><br> \
Unix time, or POSIX time, is a system for describing instants in time, defined as the number \
of seconds that have elapsed since 00:00:00 Coordinated Universal Time (UTC), Thursday, 1 January 1970, \
not counting leap seconds.<br> \
It is used widely in Unix-like and many other operating systems and file formats. \
Due to its handling of leap seconds, it is neither a linear representation of time nor a true \
representation of UTC. Unix time may be checked on most Unix systems by typing \
date +%s on the command line.<br><br> \
The standard Unix time_t (data type representing a point in time) is a signed integer data type, \
traditionally of 32 bits, directly encoding the Unix time number as described in the preceding \
section. Being 32 bits means that it covers a range of about 136 years in total. The minimum \
representable time is 1901-12-13, and the maximum representable time is 2038-01-19. At 03:14:07 UTC \
2038-01-19 this representation overflows.<br> \
In some newer operating systems, time_t has been widened to 64 bits. In the negative direction, \
this goes back more than twenty times the age of the universe and in the positive direction for \
approximately 293 billion years.<b><br></html>"

                font.pixelSize: largeScreen ? Theme.fontSizeSmall : Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
            }
        }
    }
}
