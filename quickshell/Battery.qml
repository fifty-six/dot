import QtQuick;
import QtQuick.Layouts;
import Quickshell.Services.UPower
import Qt5Compat.GraphicalEffects;
import Quickshell.Widgets;

Module {
    id: root

    visible: UPower.displayDevice.isLaptopBattery;

    property bool batteryCritical: {
        return UPower.onBattery && UPower.displayDevice.percentage <= 0.10;
    };

    color: text.color;

    RowLayout {
        Text {
            id: text

            color: {
                let device = UPower.displayDevice;

                if (device.percentage >= 0.95) {
                    return "light green";
                }

                if (!UPower.onBattery) {
                    return "#81a1c1";
                }

                return "white";
            }

            text: `${Math.round(UPower.displayDevice.percentage * 100)}%`;

            font.pointSize: 10;
            font.family: "Fira Mono";
        }
        IconImage {
            source: {
                let percent = Math.round(UPower.displayDevice.percentage * 10) * 10;

                console.debug(`${UPower.displayDevice.percentage} -> ${percent}`);

                let powered = UPower.onBattery ? "" : "-charging";

                let res = `image://icon/battery-level-${percent}${powered}-symbolic`;
                console.debug(res);
                return res;
            }

            visible: true
            implicitSize: 12
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            Layout.preferredHeight: 12
            Layout.preferredWidth: 12

            layer.enabled: true
            layer.effect: ColorOverlay { color: text.color }
        }

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
