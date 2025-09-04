import QtQuick;
import Quickshell.Services.UPower

import "Module.qml"

Module {
    id: root

    visible: UPower.displayDevice.isLaptopBattery;

    property bool batteryCritical: {
        return UPower.onBattery && UPower.displayDevice.percentage <= 0.10;
    };

    color: text.color;

    Text {
        id: text

        color: {
            let device = UPower.displayDevice;

            if (device.percentage >= 0.95)
            return "light green";

            if (!UPower.onBattery)
            return "#81a1c1";

            return "white";
        }

        text: `${Math.round(UPower.displayDevice.percentage * 100)}%`;

        font.pointSize: 10;
        font.family: "Fira Mono";
    }

    //
    // We need a transition *out* of critical
    // otherwise when we unplug it'll stay with the 
    // current background and look terrible
    // 
    PropertyAnimation {
        running: !root.batteryCritical
        to: "transparent";
        target: root;
        property: "backgroundColor";
        duration: 500;
    }

    //
    // When the battery is <15% then have
    // the background and text flash red/white
    //
    SequentialAnimation {
        loops: Animation.Infinite
        running: root.batteryCritical

        ParallelAnimation {
            PropertyAnimation { 
                to: "#eceff4";
                target: root;
                property: "backgroundColor";
                duration: 500 
            }
            PropertyAnimation { 
                to: "#4c566a";
                target: text;
                property: "color";
                duration: 500 
            }
        }

        ParallelAnimation {
            PropertyAnimation { 
                to: "#bf616a";
                target: root;
                property: "backgroundColor";
                duration: 500 
            }
            PropertyAnimation {
                to: "#eceff4"
                target: text;
                property: "color";
                duration: 500 
            }
        }
    }
}
