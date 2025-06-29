
pragma Singleton

import "root:/config"
import "root:/utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property list<string> colourNames: ["rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach", "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender"]

    property bool showPreview
    property bool endPreviewOnNextChange
    property bool light
    readonly property Colours palette: showPreview ? preview : current
    readonly property Colours current: Colours {}
    readonly property Colours preview: Colours {}
    readonly property Transparency transparency: Transparency {}

    function alpha(c: color, layer: bool): color {
        if (!transparency.enabled)
            return c;
        c = Qt.rgba(c.r, c.g, c.b, layer ? transparency.layers : transparency.base);
        if (layer)
            c.hsvValue = Math.max(0, Math.min(1, c.hslLightness + (light ? -0.2 : 0.2)));
        return c;
    }

    function on(c: color): color {
        if (c.hslLightness < 0.5)
            return Qt.hsla(c.hslHue, c.hslSaturation, 0.9, 1);
        return Qt.hsla(c.hslHue, c.hslSaturation, 0.1, 1);
    }

    function load(data: string, isPreview: bool): void {
        const colours = isPreview ? preview : current;
        for (const line of data.trim().split("\n")) {
            let [name, colour] = line.split(" ");
            name = name.trim();
            name = colourNames.includes(name) ? name : `m3${name}`;
            if (colours.hasOwnProperty(name))
                colours[name] = `#${colour.trim()}`;
        }

        if (!isPreview || (isPreview && endPreviewOnNextChange)) {
            showPreview = false;
            endPreviewOnNextChange = false;
        }
    }

    function setMode(mode: string): void {
        setModeProc.command = ["caelestia", "scheme", "dynamic", "default", mode];
        setModeProc.startDetached();
    }

    Process {
        id: setModeProc
    }

    FileView {
        path: `${Paths.state}/scheme/current-mode.txt`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.light = text() === "light"
    }

    FileView {
        path: `${Paths.state}/scheme/current.txt`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.load(text(), false)
    }

    component Transparency: QtObject {
        readonly property bool enabled: false
        readonly property real base: 0.78
        readonly property real layers: 0.58
    }

    
component Colours: QtObject {
    // Material 3 Colors (blended from Rxyhn + Decay Dark)
    property color m3primary_paletteKeyColor: "#a189ea"
    property color m3secondary_paletteKeyColor: "#7f7b99"
    property color m3tertiary_paletteKeyColor: "#c475b8"
    property color m3neutral_paletteKeyColor: "#5e5c6c"
    property color m3neutral_variant_paletteKeyColor: "#575664"

    // Surface/Background (dark)
    property color m3background: "#0e1013"
    property color m3onBackground: "#d7d7db"
    property color m3surface: "#0e1013"
    property color m3surfaceDim: "#090a0e"
    property color m3surfaceBright: "#1c1e24"
    property color m3surfaceContainerLowest: "#040507"
    property color m3surfaceContainerLow: "#111318"
    property color m3surfaceContainer: "#16181d"
    property color m3surfaceContainerHigh: "#1c1e24"
    property color m3surfaceContainerHighest: "#2a2b31"
    property color m3onSurface: "#d7d7db"
    property color m3surfaceVariant: "#1e2026"
    property color m3onSurfaceVariant: "#b3b1c2"
    property color m3inverseSurface: "#d7d7db"
    property color m3inverseOnSurface: "#1c1e24"
    property color m3outline: "#7a7890"
    property color m3outlineVariant: "#3c3b48"
    property color m3shadow: "#000000"
    property color m3scrim: "#000000"
    property color m3surfaceTint: "#a189ea"

    // Primary
    property color m3primary: "#a189ea"
    property color m3onPrimary: "#1a1032"
    property color m3primaryContainer: "#3b1c36"
    property color m3onPrimaryContainer: "#ded0ff"
    property color m3inversePrimary: "#5f4b9c"

    // Secondary
    property color m3secondary: "#a8a4c0"
    property color m3onSecondary: "#d89ac6"
    property color m3secondaryContainer: "#d89ac6"
    property color m3onSecondaryContainer: "#dad7ee"

    // Tertiary
    property color m3tertiary: "#d89ac6"
    property color m3onTertiary: "#3b1c36"
    property color m3tertiaryContainer: "#6e3a5b"
    property color m3onTertiaryContainer: "#fddbef"

    // Error (stylized as pink/purple highlight)
    property color m3error: "#ce69b2"
    property color m3onError: "#32002c"
    property color m3errorContainer: "#5a003b"
    property color m3onErrorContainer: "#ffd8ed"

    // Fixed (muted versions)
    property color m3primaryFixed: "#ded0ff"
    property color m3primaryFixedDim: "#a189ea"
    property color m3onPrimaryFixed: "#180c2c"
    property color m3onPrimaryFixedVariant: "#322456"

    property color m3secondaryFixed: "#dad7ee"
    property color m3secondaryFixedDim: "#a8a4c0"
    property color m3onSecondaryFixed: "#1a1929"
    property color m3onSecondaryFixedVariant: "#3a384d"

    property color m3tertiaryFixed: "#fddbef"
    property color m3tertiaryFixedDim: "#d89ac6"
    property color m3onTertiaryFixed: "#2d0e24"
    property color m3onTertiaryFixedVariant: "#6e3a5b"

    // Accent Names (reused for compatibility)
    property color rosewater: "#d2bcff"
    property color flamingo: "#db98e0"
    property color pink: "#ce69b2"
    property color mauve: "#a189ea"
    property color red: "#e05b66"
    property color maroon: "#c2707a"
    property color peach: "#df9098"
    property color yellow: "#e5be5d"
    property color green: "#a3be8c"
    property color teal: "#8ec07c"
    property color sky: "#81a2f8"
    property color sapphire: "#5974cc"
    property color blue: "#5d84d6"
    property color lavender: "#b1bfff"
}
}
