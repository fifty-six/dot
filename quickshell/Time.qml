import QtQuick;
import QtQuick.Layouts;
import Quickshell;

Module {
    id: root
    color: text.color

    Item {
        id: rect

        Layout.alignment: Qt.AlignHCenter

        implicitWidth: text.width + 10
        implicitHeight: text.height

        // State moment
        property bool is_date: false;

        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            id: text

            color: "#a3be8c"

            text: new Date().toTimeString().split()[0]

            font.pointSize: 10;
            font.family: "Fira Mono";

            Timer {
                id: timer
                interval: 200
                running: true
                repeat: true
                onTriggered: {
                    if (rect.is_date) {
                        text.text = new Date().toISOString().split("T")[0];
                    } else {
                        text.text = new Date().toTimeString().split()[0];
                    }
                }
            }

        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                rect.is_date = !rect.is_date
                timer.triggered()
            }
        }
    }
}
