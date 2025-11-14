import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    // I still don't get why I need this lowkey
    implicitHeight: root.implicitHeight

    Layout.preferredWidth: rows.implicitWidth

    Module {
        id: root
        color: text.color

        RowLayout {
            id: rows

            spacing: 5

            Text {
                id: text

                color: Pipewire.defaultAudioSink?.audio.muted ? "#3b4252" : "#b48ead"

                text: `${Math.round(Pipewire.defaultAudioSink?.audio.volume * 100 ?? 0)}%`

                font.pointSize: 10;
                font.family: "Fira Mono";

            }

            IconImage {
                Layout.alignment: Qt.AlignVCenter

                source: Pipewire.defaultAudioSink?.audio.muted
                    ? Quickshell.iconPath("audio-volume-muted-symbolic")
                    : Quickshell.iconPath("audio-volume-high-symbolic")

                implicitSize: 12


                layer.enabled: true
                layer.effect: ColorOverlay { color: text.color }
            }

        }
    }

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink, Pipewire.defaultAudioSource ]
    }


    MouseArea {
        anchors.fill: root
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: e => {
            if (e.button == Qt.RightButton) {
                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
            } else {
                Quickshell.execDetached(["pavucontrol"])
            }
        }

        onWheel: e => {
            // yes it is in fact 5k to make this not explode your ears if you slightly scroll
            Pipewire.defaultAudioSink.audio.volume += e.angleDelta.y / 5000;
        }
    }
}
