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

    Component.onCompleted: {
        if (this.content.length == 0) {
            return;
        }

        // if (color === undefined) {
        //     color = content[0].color ? Qt.binding(() => content[0].color) : "white";
        // }
    }

    Rectangle {
        id: rect

        Layout.alignment: Qt.AlignHCenter

        color: "transparent";

        Component.onCompleted: {
            let h = 0;
            let w = 0;

            for (let child of rect.children) {
                child.anchors.verticalCenter = rect.verticalCenter;
                child.anchors.horizontalCenter = rect.horizontalCenter;

                h += child.implicitHeight;
                w = Math.max(w, child.implicitWidth);
            }

            implicitHeight = h;
            implicitWidth = w + root.horizontalPadding;
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
