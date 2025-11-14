import Quickshell;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Io;
import Qt5Compat.GraphicalEffects;

Module {
    color: text.color

    RowLayout {
        Layout.alignment: Qt.AlignCenter

        Text {
            Layout.alignment: Qt.AlignCenter
            id: text

            color: "white";
            text: "Unknown";

            font.pointSize: 10;
            font.family: "Fira Mono";
        }

        Image {
            // WARNING: using the same id as another image seems to make it overlay and break.
            // also: visible needs to be false or it uses the non-existent icon in the width
            id: net_icon
            visible: false
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            Layout.preferredHeight: 12
            Layout.preferredWidth: 12

            layer.enabled: true
            layer.effect: ColorOverlay { color: "#a3be8c" }
        }
    }

    Process {
        running: true
        command: ["whereis", "nmcli"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.split(" ").length > 1) {
                    watcher.running = true;
                } else {
                    root.visible = false;
                }
            }
        }
    }

    Process {
        id: watcher
        command: ["nmcli", "m"]
        stdout: SplitParser {
            onRead: nmcli.running = true
        }
    }


    Process {
        id: nmcli
        command: ["jc", "nmcli", "d"]

        stdout: StdioCollector {
            onStreamFinished: {
                let json = JSON.parse(this.text);

                // *Probably* the main interface: (wifi or ethernet) + not virtual
                let main = [...json].find(o => (o.type === "wifi" || o.type === "ethernet") && !(o.name?.startsWith("v") ?? false));

                if (main === undefined)
                    return;

                let connected = main.state === "connected";

                text.color = connected
                    ? "#a3be8c"
                    : "#bf616a";

                if (!connected) {
                    text.text = "disconnected";
                    net_icon.visible = false;
                    return;
                }

                net_icon.visible = true;

                if (main.type === "wifi") {
                    text.text = `${main.connection}`;
                    net_icon.source = "image://icon/network-wireless-symbolic";

                } else {
                    // Wired connection 1 just doesn't sound as cool
                    text.text = main.device;
                    net_icon.source = "image://icon/network-wired-symbolic";
                }
            }
        }
    }
}
