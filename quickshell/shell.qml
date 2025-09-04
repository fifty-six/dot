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
            implicitHeight: 34

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent";


            // This one is the actual bar
            Rectangle {
                id: bar
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                anchors.fill: parent
                radius: 12
                color: Qt.rgba(0.5, 0.5, 0.5, 0.1);

                RowLayout {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }


                    Workspaces {
                        id: ws
                        Layout.alignment: Qt.AlignVCenter;
                    }

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

                    spacing: 20;

                    Battery {
                        implicitHeight: parent.height;
                        implicitWidth: 20;
                    }

                    Light {
                        // implicitWidth: 160;
                        implicitHeight: parent.height;
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillHeight: true;
                    }

                    // SysTray {}
                    // Volume {}
                    Network {}
                } 
            }
        }
    }
}


