import QtQuick;
import QtQuick.Layouts;
import Quickshell;

ColumnLayout {
    id: root
    spacing: 5;

    Layout.alignment: Qt.AlignBottom

    Rectangle { 
        id: rect

        Layout.alignment: Qt.AlignHCenter

        implicitWidth: text.width + 10
        implicitHeight: text.height
        color: "transparent"

        // State moment
        property bool is_date: false;

        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            id: text

            color: {
                    return "#a3be8c";
            }

            text: {
                return new Date().toTimeString().split()[0];
            }

            font.pointSize: 10;
            font.family: "Fira Mono";

            Timer {
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
            }
        }
    }

    Rectangle {
        Layout.alignment: Qt.AlignBottom
        implicitHeight: 2;
        implicitWidth: text.width + 10;
        color: text.color;
    }
}
