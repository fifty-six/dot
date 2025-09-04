pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: window
    property string light: "light.bedroom_hue"
    implicitWidth: slider.implicitWidth
    implicitHeight: slider.implicitHeight
    // color: contentItem.palette.active.window

    Slider {
        id: slider
        from: 0
        to: 255

        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        anchors.horizontalCenter: parent.horizontalCenter

        Layout.fillWidth: true

        onMoved: {
            //console.log(this.value);

            if (this.value === null)
                return;

            let brightness = Math.round((this.value / 255) * 100);

            brightnessProc.exec(["ha", "set", window.light, `${brightness}`]);

            return this.value;
        }

        Process {
            id: brightnessProc
        }

        Process {
            id: haProc

            running: true
            command: ["ha", "brightness-raw", window.light]

            stdout: StdioCollector {
                onStreamFinished: {
                    // console.log(this.text);
                    slider.value = parseInt(this.text);
                }
            }
        }
    }
}
