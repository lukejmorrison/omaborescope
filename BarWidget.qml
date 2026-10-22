import QtQuick
import Quickshell.Io

Item {
    id: root

    property var bar: null

    implicitWidth: label.implicitWidth + 20
    implicitHeight: 28

    function scriptPath() {
        var path = Qt.resolvedUrl("bin/omaborescope").toString()
        if (path.indexOf("file://") === 0)
            path = decodeURIComponent(path.substring(7))
        return path
    }

    function openPanel() {
        var shell = bar && bar.shell ? bar.shell : null
        if (shell && shell.summon) {
            shell.summon("lukejmorrison.omaborescope", "{}")
            return
        }
        fallback.command = [scriptPath(), "watch"]
        fallback.running = true
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: "Scope"
        color: root.bar && root.bar.barForeground ? root.bar.barForeground : "white"
        font.pixelSize: 13
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.openPanel()
    }

    Process {
        id: fallback
    }
}
