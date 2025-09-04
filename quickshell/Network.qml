import QtQuick;
import QtQuick.Layouts;
import Quickshell.Io;

Module {
    id: root;

    color: text.color

    Text {
        Layout.alignment: Qt.AlignCenter
        id: text

        color: "white";
        text: "Unknown";

        font.pointSize: 10;
        font.family: "Fira Mono";
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
                    return;
                }

                if (main.type === "wifi") {
                    text.text = main.connection;
                } else {
                    // Wired connection 1 just doesn't sound as cool
                    text.text = main.device;
                }
            }
        }
    }
}
