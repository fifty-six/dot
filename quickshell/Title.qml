import QtQuick;
import QtQuick.Layouts;
import Quickshell;

import "Services";
import "Services/NiriService.qml";

Text { 
    Layout.alignment: Qt.AlignHCenter;

    color: "white";
    text: NiriService.title 
    font.family: "Fira Mono"
    font.pointSize: 10.5;
}
