pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

import ".";

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            property var modelData
            screen: modelData
            implicitHeight: 37
            id: toplevel

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent";

            // This one is the actual bar
            Rectangle {
                id: bar
                anchors.fill: parent
                color: Qt.rgba(0.01, 0.01, 0.01, 0.7);

                RowLayout {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }


                    Workspaces {
                        id: ws
                        Layout.alignment: Qt.AlignVCenter;
                    }

                    // Button {
                    //     id: button
                    //     text: "Lights?"
                    //     onClicked: popup.visible = !popup.visible;

                    //     // TODO: this is bounded by the thing it's in. i need to unparent it? same issue with the popup i think?
                    //     Pane { id: popup; y: -25; visible: false; Lights {} } // closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent }
                    // }

                }

                RowLayout {
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter;
                        top: parent.top
                    }

                    Title {}

                }

                RowLayout {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter;
                        rightMargin: 20
                    }

                    layoutDirection: Qt.RightToLeft;

                    spacing: 15;

                    Time { }

                    Battery { }

                    // SysTray {}

                    Network { }

                    Volume { }

                    Brightness { }

                    Light {
                        implicitHeight: parent.height;
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillHeight: true;
                    }


                }
            }
        }
    }
}


