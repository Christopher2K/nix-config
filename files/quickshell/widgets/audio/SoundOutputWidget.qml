import QtQuick
import Quickshell.Services.Pipewire
import "root:/utils"

IconWithLabel {
    id: root

    property PwNode defaultSink: Pipewire.defaultAudioSink
    property PwNodeAudio defaultAudio: defaultSink.audio

    property bool isMuted: defaultAudio.muted || defaultAudio.volume === 0
    property real volume: {
        Math.round(defaultAudio.volume * 100)
    }

    PwObjectTracker {
        objects: [defaultSink]
    }

    icon: {
        if (isMuted) return "";
        if (defaultAudio.volume > 0.5) return "";
        return "";
    }
    iconColor: isMuted ?  ThemeColors.base08 : ThemeColors.base00
    label: `${volume}%`
}
