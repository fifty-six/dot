import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item { 
    Layout.alignment: Qt.AlignBottom
    width: root.width

        PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    ColumnLayout {
        id: root
        spacing: 5

        anchors {
            bottom: parent.bottom
        }

        RowLayout { 
            id: rows

            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Text {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                id: text

                color: {
                    return "#a3be8c";
                }

                text: {
                    return `${Math.round(Pipewire.defaultAudioSink?.audio.volume * 100 ?? 0)}%`;
                }

                font.pointSize: 10;
                font.family: "Fira Mono";

            }

            IconImage {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                source: Quickshell.iconPath("audio-volume-high-symbolic")
                implicitSize: 12

                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: "#a3be8c"
                }
            }

        }

        Rectangle {
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
            implicitHeight: 2;
            implicitWidth: rows.implicitWidth + 10
            color: text.color;
        }

    }

    MouseArea {
        anchors.fill: root
        onWheel: function (e) {
            // yes it is in fact 10k to make this not explode your ears if you slightly scroll
            Pipewire.defaultAudioSink.audio.volume += e.angleDelta.y / 10000;
        }
    }
}
