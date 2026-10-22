import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: root

    property var shell: null
    property var manifest: null
    property bool opened: false
    property string scopeState: "off"
    property string recording: "no"
    property string message: "Click the thumbwheel and wait for the slow green flash."
    property string errorText: ""

    function pluginId() {
        return (manifest && manifest.id) ? manifest.id : "lukejmorrison.omaborescope"
    }

    function scriptPath() {
        var path = Qt.resolvedUrl("bin/omaborescope").toString()
        if (path.indexOf("file://") === 0)
            path = decodeURIComponent(path.substring(7))
        return path
    }

    function open(payloadJson) {
        opened = true
        refresh()
        Qt.callLater(function() {
            if (opened)
                keyCatcher.forceActiveFocus()
        })
    }

    function close() {
        opened = false
    }

    function dismiss() {
        if (shell && shell.hide)
            shell.hide(pluginId())
        else
            close()
    }

    function run(args) {
        errorText = ""
        var command = [scriptPath()]
        for (var i = 0; i < args.length; i++)
            command.push(args[i])
        action.command = command
        action.running = true
    }

    function note(line) {
        var text = String(line || "")
        if (text.indexOf("scope=") === 0)
            scopeState = text.substring(6)
        else if (text.indexOf("recording=") === 0)
            recording = text.substring(10)
        else if (text.indexOf("saved=") === 0)
            message = "Saved " + text.substring(6)
        else if (text.indexOf("watching=") === 0)
            message = "Live picture is open. Press q in that window to close it."
        else if (text.indexOf("left=") === 0)
            message = "Left the scope Wi-Fi."
        else if (text.indexOf("opened=") === 0)
            message = "Opened the Android download."
        else if (text.indexOf("stopped=") === 0)
            message = "Stopped."
    }

    function refresh() {
        statusProc.command = [scriptPath(), "status"]
        statusProc.running = true
    }

    Process {
        id: statusProc
        stdout: SplitParser {
            onRead: function(line) { root.note(line) }
        }
    }

    Process {
        id: action
        stdout: SplitParser {
            onRead: function(line) { root.note(line) }
        }
        stderr: SplitParser {
            onRead: function(line) { root.errorText = String(line || "") }
        }
        onExited: function(code) {
            if (code !== 0 && root.errorText === "")
                root.errorText = "That did not work."
            root.refresh()
        }
    }

    PanelWindow {
        visible: root.opened
        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "omaborescope"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.72)
            MouseArea { anchors.fill: parent; onClicked: root.dismiss() }
        }

        Item {
            id: keyCatcher
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: root.dismiss()

            Rectangle {
                anchors.centerIn: parent
                width: 460
                height: card.implicitHeight + 36
                radius: 16
                color: "#141414"
                border.color: "#333333"
                border.width: 1

                MouseArea { anchors.fill: parent; onClicked: {} }

                ColumnLayout {
                    id: card
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 18
                    spacing: 12

                    Text {
                        text: "OmaBorescope"
                        color: "white"
                        font.pixelSize: 22
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.scopeState === "ready" ? "Scope is connected." : "Scope is not on the air yet."
                        color: root.scopeState === "ready" ? "#8fd18f" : "#d0d0d0"
                        font.pixelSize: 14
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        text: root.message
                        color: "#bdbdbd"
                        font.pixelSize: 13
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        visible: root.errorText !== ""
                        text: root.errorText
                        color: "#ff8a80"
                        font.pixelSize: 13
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                    GridLayout {
                        columns: 3
                        columnSpacing: 8
                        rowSpacing: 8
                        Layout.fillWidth: true

                        ActionButton { label: "Watch"; onClicked: root.run(["watch"]) }
                        ActionButton { label: "Photo"; onClicked: root.run(["snap"]) }
                        ActionButton {
                            label: root.recording === "yes" ? "Recording" : "Record"
                            onClicked: root.run(["record"])
                        }
                        ActionButton { label: "Stop"; onClicked: root.run(["stop"]) }
                        ActionButton { label: "Android"; onClicked: root.run(["android"]) }
                        ActionButton { label: "Disconnect"; onClicked: root.run(["leave"]) }
                    }
                }
            }
        }
    }

    component ActionButton: Rectangle {
        id: button
        property string label: ""
        signal clicked()
        implicitWidth: 132
        implicitHeight: 44
        radius: 8
        color: press.pressed ? "#3c3c3c" : "#2a2a2a"
        Layout.fillWidth: true

        Text {
            anchors.centerIn: parent
            text: button.label
            color: "white"
            font.pixelSize: 15
        }

        MouseArea {
            id: press
            anchors.fill: parent
            onClicked: button.clicked()
        }
    }
}
