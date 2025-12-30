pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property string date: {
        Qt.formatDateTime(clock.date, "ddd MMM d");
    }
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh:mm");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
