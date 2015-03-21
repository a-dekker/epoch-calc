/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow {
    id: mainapp
    property string uxTime_now: ''
    property string uxTime: 'Not calculated'
    property string calc_date: ''
    property string calc_time: ''
    property string utcTime: ''
    property string localTime: ''
    property bool viewable: cover.status === Cover.Active || applicationActive

    initialPage: Component {
        MainPage {
        }
    }

    cover: CoverPage {
        id: cover
    }

    function get_utc_datetime() {

        var utc_datetime = new Date().toUTCString().split(" ")
        var utc_datetime_formatted = utc_datetime[0] + " " + utc_datetime[1] + " "
                + utc_datetime[2] + " " + utc_datetime[4] + " " + utc_datetime[3]
        return utc_datetime_formatted
    }

    function get_local_datetime() {

        var local_datetime = new Date().toString().split(" ")
        var local_datetime_formatted = local_datetime[0] + " " + local_datetime[1] + " "
                + local_datetime[2] + " " + local_datetime[4] + " " + local_datetime[3]
        return local_datetime_formatted
    }

    Timer {
        id: timerclock

        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            uxTime_now = Math.round(new Date().getTime() / 1000.0) + " secs"
            utcTime = get_utc_datetime()
            localTime = get_local_datetime()
        }
        running: viewable
    }

    Component.onCompleted: {
        timerclock.start()
    }
}
