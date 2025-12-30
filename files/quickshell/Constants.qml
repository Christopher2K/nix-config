pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // Helpers
    readonly property int barHeight: 40

    // Fonts stuff
    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 10

    // Theme info
    readonly property string themeName: "Gruvbox Light"
    readonly property string themeVariant: "light"

    // Colors (Base16 Gruvbox Light)
    readonly property color base00: "#fbf1c7"
    readonly property color base01: "#ebdbb2"
    readonly property color base02: "#d5c4a1"
    readonly property color base03: "#bdae93"
    readonly property color base04: "#7c6f64"
    readonly property color base05: "#3c3836"
    readonly property color base06: "#282828"
    readonly property color base07: "#1d2021"
    readonly property color base08: "#cc241d"
    readonly property color base09: "#d65d0e"
    readonly property color base0A: "#d79921"
    readonly property color base0B: "#98971a"
    readonly property color base0C: "#689d6a"
    readonly property color base0D: "#458588"
    readonly property color base0E: "#b16286"
    readonly property color base0F: "#9d0006"

    // Semantic aliases
    readonly property color background: base00
    readonly property color foreground: base05
    readonly property color accent: base0D
}
