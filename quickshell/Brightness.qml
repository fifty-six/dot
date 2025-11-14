import QtQuick;
import QtQuick.Layouts;
import Quickshell;
import Quickshell.Io;

Item {
    id: root;

    Layout.alignment: Qt.AlignBottom

    property double percent;

    property color color: "#ebcb8b";
    onPercentChanged: {
        canvas.requestPaint()
    }

    implicitHeight: cols.implicitHeight;
    implicitWidth: cols.implicitWidth;

    Process {
        id: setter
    }

    MouseArea {
        anchors.fill: root
        onWheel: function (e) {
            let next = root.percent + e.angleDelta.y / 1000;

            if (next < 0 || next > 1) {
                return;

            }

            root.percent = next;
            setter.exec(["brightnessctl", "set", `${(next * 100).toFixed(0)}%`]);
        }
    }


    Module {
        id: cols

        implicitWidth: text.implicitWidth;

        color: text.color

        RowLayout {
            id: rows

            Layout.alignment: Qt.AlignCenter

            Text {
                Layout.alignment: Qt.AlignCenter
                id: text

                color: root.color;
                text: `${(root.percent * 100).toFixed(0)}%`;

                font.pointSize: 10;
                font.family: "Fira Mono";
            }

            Item {
                implicitWidth: 12
                implicitHeight: 12

                Canvas {
                    id: canvas
                    anchors.fill: parent
                    antialiasing: true

                    renderTarget: Canvas.FramebufferObject
                    renderStrategy: Canvas.Cooperative

                    width: parent.width * 40
                    height: parent.height * 40
                    smooth: true;
                    transformOrigin: Item.TopLeft

                    onPaint: {
                        var ctx = getContext("2d");

                        var x = width / 2;
                        var y = height / 2;

                        var radius = (width / 2) - 1;
                        var startAngle = (Math.PI / 180) * 270;
                        var fullAngle = (Math.PI / 180) * (270 + 360);
                        var progressAngle = (Math.PI / 180) * (270 + 100);

                        ctx.reset()

                        ctx.strokeStyle = root.color;
                        ctx.lineWidth = 1;
                        ctx.beginPath();
                        ctx.arc(x, y, radius, 0, Math.PI * 2);
                        ctx.stroke();

                        ctx.fillStyle = root.color;
                        ctx.beginPath();
                        ctx.moveTo(x,y);
                        ctx.arc(x, y, radius, 0, (Math.PI * 2) * root.percent);
                        ctx.lineTo(x, y)
                        ctx.fill();
                    }

                }
            }
        }

        Process {
            running: true
            command: ["whereis", "brightnessctl"]
            stdout: StdioCollector {
                onStreamFinished: {
                    if (this.text.split(" ").length > 1) {
                        // watcher.running = true;
                        // timer maybe
                        brightnessctl.running = true;
                    } else {
                        root.visible = false;
                    }
                }
            }
        }

        Process {
            id: brightnessctl
            command: ["brightnessctl", "-m"]

            stdout: StdioCollector {
                onStreamFinished: {
                    let [_device, _, cur, _percent, max] = this.text.split(",");
                    root.percent = parseInt(cur) / parseInt(max);
                }
            }
        }

        // Rectangle {
        //     Layout.alignment: Qt.AlignBottom
        //     implicitHeight: 2;
        //     implicitWidth: rows.width + 5;
        //     color: text.color;
        // }
    }
}
