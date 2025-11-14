pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

import "Services";
import "Services/NiriService.qml";

Item {
    Rectangle {
        color: Qt.rgba(1, 1, 1, 0.15);


        radius: 10;

        anchors.horizontalCenter: rows.horizontalCenter
        anchors.verticalCenter: rows.verticalCenter
        implicitWidth: rows.implicitWidth + 15
        implicitHeight: rows.implicitHeight + 14
    }


    RowLayout {
        id: rows

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter;
        anchors.leftMargin: 20

        Repeater {
            id: repeater
            model: NiriService.workspace_cnt;

            // so-called "rectangle"
            Rectangle {
                id: ws
                required property int index

                radius: 9;
                implicitHeight: 11 * 1.2;
                implicitWidth: 11 * 1.2 // ws.active_idx === index ? 15 : 9;

                border.color: "white";
                border.width: 1;
                color: "transparent";

                MouseArea {
                    anchors.fill: parent

                    onClicked: _ => {
                        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", (parent.index + 1).toString()])
                    }
                }

                states: State {
                    name: "active"
                    when: NiriService.active_idx == ws.index
                    PropertyChanges {
                        ws {
                            implicitWidth: 15 * 2
                            color: "white"
                        }
                    }
                }

                transitions: Transition {
                    from: ""
                    to: "active"
                    reversible: true

                    ParallelAnimation {
                        NumberAnimation {
                            property: "implicitWidth"
                            duration: 100
                            easing.type: Easing.InOutBounce
                        }
                        ColorAnimation { duration: 100 }
                    }
                }
            }
        }
    }
}
