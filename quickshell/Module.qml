import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
    id: root
    spacing: 5;

    Layout.alignment: Qt.AlignBottom

    default property alias content: rect.data
    property int horizontalPadding: 0;
    property color color;
    property alias backgroundColor: rect.color;

    Rectangle {
        id: rect

        Layout.alignment: Qt.AlignHCenter

        color: "transparent";

        implicitHeight: {
            return rect.children.reduce((a, b) => a + b.implicitHeight, 0);
        }

        implicitWidth: {
            return Math.max(...rect.children.map(x => x.implicitWidth));
        }
    }

    Rectangle {
        Layout.alignment: Qt.AlignBottom
        implicitHeight: 2;
        color: root.color;

        implicitWidth: {
            let w = Math.max(...root.content.map(x => x.implicitWidth ?? 0));
            return w + root.horizontalPadding;
        }
    }
}
