import QtQuick;
import QtQuick.Layouts;
import Quickshell;

import "Services";
import "Services/NiriService.qml";

Text {
    Layout.alignment: Qt.AlignHCenter;
    Layout.maximumWidth: 350;

    color: "white";
    text: NiriService.title
    font.family: "Fira Mono"
    font.pointSize: 10.5;

    elide: Text.ElideRight
    clip: true
}
