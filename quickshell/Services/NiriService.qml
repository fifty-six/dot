pragma Singleton

import Quickshell
import Quickshell.Io

import "niri.mjs" as Niri;

Singleton {
    id: root

    property int active_idx;
    property int workspace_cnt;

    property string title;

    property var windows;

    Process {
        id: niriEventStream
        running: true
        command: ["niri", "msg", "--json", "event-stream"]

        stdout: SplitParser {
            onRead: data => {
                Niri.handleEvent(
                    data,
                    root
                );
            };
        }
    }
}
