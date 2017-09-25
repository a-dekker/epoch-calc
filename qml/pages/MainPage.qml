import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted
    property bool largeScreen: Screen.sizeCategory === Screen.Large ||
                               Screen.sizeCategory === Screen.ExtraLarge
    onStatusChanged: {
        if (status === PageStatus.Inactive) {
            // stop timer when not on this Page
            timerclock.stop()
        } else if (status === PageStatus.Active) {
            // resume timer when back on this Page
            timerclock.start()
        }
    }

    function get_local_time() {

        var loc_time = new Date()
        var local_time_formatted = ("0" + loc_time.getHours()).slice(
                    -2) + ":" + ("0" + loc_time.getMinutes()).slice(
                    -2) + ":" + ("0" + loc_time.getSeconds()).slice(-2)
        return local_time_formatted
    }

    function on_update_ux_time() {

        var ux_sec_new = Math.round(
                    new Date(dateField.text + " " + timeField.text).getTime(
                        ) / 1000.0)
        var ux_millisec = new Date(ux_sec_new * 1000)
        var utc_datetime = ux_millisec.toUTCString().split(" ")
        var utc_datetime_formatted = utc_datetime[0] + " " + utc_datetime[1] + " "
                + utc_datetime[2] + " " + utc_datetime[4] + " " + utc_datetime[3] + " GMT"
        // update fields
        ux_time_textfield.text = ux_sec_new
        ux_time_textfield.focus = false
        mainapp.uxTime = ux_time_textfield.text
        mainapp.calc_date = dateField.text
        mainapp.calc_time = timeField.text
        calculated_utc_time_portrait.text = utc_datetime_formatted
        calculated_utc_time_landscape.text = utc_datetime_formatted
    }

    function on_update_ux_secs() {
        var ux_secs = new Date(ux_time_textfield.text * 1000)
        var hours = ux_secs.getHours()
        var minutes = ux_secs.getMinutes()
        var seconds = ux_secs.getSeconds()
        var year = ux_secs.getFullYear()
        var month = ux_secs.getMonth() + 1 // js starts at 0
        var day = ux_secs.getDate()
        var utc_datetime = ux_secs.toUTCString().split(" ")
        var utc_datetime_formatted = utc_datetime[0] + " " + utc_datetime[1] + " "
                + utc_datetime[2] + " " + utc_datetime[4] + " " + utc_datetime[3] + " GMT"
        // update fields
        timeField.text = (hours > 9 ? hours : "0" + hours) + ":"
                + (minutes > 9 ? minutes : "0" + minutes) + ":"
                + (seconds > 9 ? seconds : "0" + seconds)
        dateField.text = year + "-" + (month > 9 ? month : "0" + month) + "-"
                + (day > 9 ? day : "0" + day)
        calculated_utc_time_portrait.text = utc_datetime_formatted
        calculated_utc_time_landscape.text = utc_datetime_formatted
        mainapp.uxTime = ux_time_textfield.text
        mainapp.calc_date = dateField.text
        mainapp.calc_time = timeField.text
    }

    QtObject {
        id: local_datetime
        property var locale: Qt.locale()
        property date currentDateTime: new Date()
        property string timezone: currentDateTime.toLocaleString(locale, "t")
        property string local_date: currentDateTime.toLocaleString(locale,
                                                                   "yyyy-MM-dd")
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Help")
                onClicked: pageStack.push(Qt.resolvedUrl("Help.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            // set spacing considering the width/height ratio
            spacing: largeScreen ? Theme.paddingLarge : ( isPortrait ? Theme.paddingMedium : Theme.paddingSmall )
            PageHeader {
                title: qsTr("epoch-calc")
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || largeScreen
            }
            Label {
                x: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Unix time calculator")
                font.bold: true
            }
            Row {
                TextField {
                    id: dateField
                    label: qsTr("Pick date")
                    readOnly: true
                    onClicked: {
                        var day = dateField.text.split("-")[2]
                        var month = dateField.text.split(
                                    "-")[1] - 1 // js: january = month[0]
                        var year = dateField.text.split("-")[0]
                        console.log(month)
                        var dialog = pageStack.push(datePickerComponent, {
                                                        date: new Date(year,
                                                                       month,
                                                                       day)
                                                    })
                        dialog.accepted.connect(function () {
                            dateField.text = dialog.year + "-"
                                    + (dialog.month > 9 ? dialog.month : "0" + dialog.month) + "-"
                                    + (dialog.day > 9 ? dialog.day : "0" + dialog.day)
                            // update the date/time info
                            on_update_ux_time()
                        })
                    }
                    width: isPortrait || largeScreen ? column.width / 2 : column.width / 4
                    color: Theme.highlightColor
                    text: local_datetime.local_date
                }
                Label {
                    id: calculated_utc_time_landscape
                    text: get_utc_datetime() + " GMT"
                    color: Theme.secondaryColor
                    visible: isLandscape && ! largeScreen
                    horizontalAlignment: Text.AlignHCenter
                    width: column.width / 2
                }
                TextField {
                    id: timeField
                    label: qsTr("Pick time")
                    readOnly: true
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl(
                                                        "TimeDialog.qml"), {
                                                        infotext: "Time",
                                                        hour: timeField.text.split(
                                                                  ":")[0],
                                                        minute: timeField.text.split(
                                                                    ":")[1],
                                                        second: timeField.text.split(
                                                                    ":")[2]
                                                    })
                        dialog.accepted.connect(function () {
                            timeField.text = (dialog.hour > 9 ? dialog.hour : "0" + dialog.hour)
                                    + ":" + (dialog.minute > 9 ? dialog.minute : "0"
                                                                 + dialog.minute) + ":"
                                    + (dialog.second > 9 ? dialog.second : "0" + dialog.second)
                            on_update_ux_time()
                        })
                    }
                    color: Theme.highlightColor
                    width: isPortrait || largeScreen ? column.width / 2 : column.width / 4
                    horizontalAlignment: Text.AlignRight
                    text: get_local_time()
                }
            }

            Component {
                id: datePickerComponent
                DatePickerDialog {
                }
            }
            Label {
                id: calculated_utc_time_portrait
                text: get_utc_datetime() + " GMT"
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                visible: isPortrait || largeScreen
            }

            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                Label {
                    height: Theme.paddingLarge * 2
                    verticalAlignment: Text.AlignBottom
                    text: "Unix time in secs"
                    width: (column.width / 3)
                }
                TextField {
                    id: ux_time_textfield
                    placeholderText: "Unix secs."
                    width: (column.width - (Theme.paddingLarge * 3)) / 2
                    validator: RegExpValidator {
                        regExp: /^[0-9]{1,10}$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly
                    horizontalAlignment: Text.AlignRight
                    text: Math.round(new Date().getTime() / 1000.0)
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "OK"
                    EnterKey.onClicked: {
                        on_update_ux_secs()
                        ux_time_textfield.focus = false
                    }
                    onFocusChanged: {
                        on_update_ux_secs()
                    }
                }
                IconButton {
                    id: iconButton
                    icon.source: largeScreen ? "image://theme/icon-l-clear" : "image://theme/icon-m-clear"
                    visible: ux_time_textfield.text
                    highlighted: pressed
                    onClicked: {
                        ux_time_textfield.text = ""
                        ux_time_textfield.focus = true
                    }
                }
            }

            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || largeScreen || screen.width > 540
            }
            Label {
                x: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Current time info")
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                spacing: isLandscape ? Theme.paddingMedium : 0
                Label {
                    text: "Unix time"
                    width: isPortrait || largeScreen ? (column.width - unix_secs.width - Theme.paddingLarge * 2)
                                        / 2 : (parent.width - (Theme.paddingLarge * 2)) / 5.3
                }
                Label {
                    id: unix_secs
                    text: mainapp.uxTime_now
                    width: isPortrait || largeScreen ? (parent.width - (Theme.paddingLarge * 2))
                                        : (parent.width - (Theme.paddingLarge * 2)) / 2.5
                    horizontalAlignment: Text.AlignRight
                    color: Theme.secondaryColor
                }
                Label {
                    text: "Local TZ"
                    width: (parent.width - (Theme.paddingLarge * 2)) / 5.5
                    visible: isLandscape && ! largeScreen
                }
                Label {
                    text: local_datetime.timezone
                    width: (parent.width - (Theme.paddingLarge * 2)) / 5.2
                    horizontalAlignment: Text.AlignRight
                    color: Theme.secondaryColor
                    visible: isLandscape && ! largeScreen
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                spacing: isLandscape ? Theme.paddingMedium : 0
                Label {
                    text: "Local time"
                    width: isPortrait || largeScreen ? (column.width - local_time.width - Theme.paddingLarge * 2)
                                        / 2 : (parent.width - (Theme.paddingLarge * 2)) / 5.3
                }
                Label {
                    id: local_time
                    text: mainapp.localTime
                    width: isPortrait || largeScreen ? (parent.width - (Theme.paddingLarge * 2))
                                        : (parent.width - (Theme.paddingLarge * 2)) / 2.5
                    horizontalAlignment: Text.AlignRight
                    color: Theme.secondaryColor
                }
                Label {
                    text: "TZ offset"
                    width: (parent.width - (Theme.paddingLarge * 2)) / 5.5
                    visible: isLandscape && ! largeScreen
                }
                Label {
                    text: new Date().toString().split(" ")[5]
                    width: (parent.width - (Theme.paddingLarge * 2)) / 5.2
                    horizontalAlignment: Text.AlignRight
                    color: Theme.secondaryColor
                    visible: isLandscape && ! largeScreen
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Local TZ"
                    width: (parent.width - (Theme.paddingLarge * 2)) / 2
                    visible: isPortrait || largeScreen
                }
                Label {
                    text: local_datetime.timezone
                    width: (parent.width - (Theme.paddingLarge * 2)) / 2
                    horizontalAlignment: Text.AlignRight
                    color: Theme.secondaryColor
                    visible: isPortrait || largeScreen
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                spacing: isLandscape ? Theme.paddingMedium : 0
                Label {
                    text: "GMT time"
                    width: isPortrait || largeScreen ? (column.width - utc_time.width - Theme.paddingLarge * 2)
                                        / 2 : (parent.width - (Theme.paddingLarge * 2)) / 5.3
                }
                Label {
                    id: utc_time
                    text: utcTime //.utc_datetime_formatted
                    width: isPortrait || largeScreen ? (parent.width - (Theme.paddingLarge * 2))
                                        : (parent.width - (Theme.paddingLarge * 2)) / 2.5
                    horizontalAlignment: Text.AlignRight
                    color: Theme.secondaryColor
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "TZ offset"
                    width: (parent.width - (Theme.paddingLarge * 2)) / 2
                    visible: isPortrait || largeScreen
                }
                Label {
                    text: new Date().toString().split(" ")[5]
                    width: (parent.width - (Theme.paddingLarge * 2)) / 2
                    horizontalAlignment: Text.AlignRight
                    color: Theme.secondaryColor
                    visible: isPortrait || largeScreen
                }
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || largeScreen || screen.width > 540
            }
        }
    }
}
