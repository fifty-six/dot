import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item { 
    // I still don't get why I need this lowkey
    implicitWidth: root.implicitWidth
    implicitHeight: root.implicitHeight

    Module {
        id: root
        color: text.color

        RowLayout { 
            id: rows

            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Text {
                Layout.alignment: Qt.AlignLeft

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
    }

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }


    MouseArea {
        anchors.fill: root
        onWheel: function (e) {
            // yes it is in fact 10k to make this not explode your ears if you slightly scroll
            Pipewire.defaultAudioSink.audio.volume += e.angleDelta.y / 10000;
        }
    }
}
