import QtQuick 2.15
import QtGraphicalEffects 1.12

Rectangle {
    id: languageSelector
    anchors.fill: parent
    color: "#E6000000"
    z: 100

    property real vpx: 1.0
    property bool languageSelected: false
    property int selectedIndex: 0
    property string currentLanguage: "en"

    signal languageChosen(string languageCode)

    readonly property var languages: [
        { code: "en", name: "English", flag: "usa.png" },
        { code: "es", name: "Español", flag: "es.png" },
        { code: "pt", name: "Português", flag: "br.png" },
        { code: "fr", name: "Français", flag: "fr.png" }
    ]

    Column {
        anchors.centerIn: parent
        spacing: 40 * vpx

        Text {
            text: "SELECT LANGUAGE"
            color: "white"
            font.pixelSize: 56 * vpx
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 4
                radius: 8
                samples: 17
                color: "#80000000"
            }
        }

        Text {
            text: "Choose your preferred language"
            color: "#CCCCCC"
            font.pixelSize: 24 * vpx
            anchors.horizontalCenter: parent.horizontalCenter

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 2
                radius: 4
                samples: 9
                color: "#60000000"
            }
        }

        Column {
            spacing: 20 * vpx
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: languageSelector.languages

                Rectangle {
                    id: languageOption
                    width: 480 * vpx
                    height: 80 * vpx
                    color: languageSelector.selectedIndex === index ? "#4CAF50" : "#333333"
                    radius: 12 * vpx
                    border.width: languageSelector.selectedIndex === index ? 3 * vpx : 0
                    border.color: "#66BB6A"

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 150 }
                    }

                    scale: languageSelector.selectedIndex === index ? 1.05 : 1.0

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: languageSelector.selectedIndex === index ? 6 : 3
                        radius: languageSelector.selectedIndex === index ? 12 : 6
                        samples: 17
                        color: languageSelector.selectedIndex === index ? "#804CAF50" : "#60000000"
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 20 * vpx

                        Image {
                            id: flagImage
                            source: "assets/image/language/" + modelData.flag
                            width: 64 * vpx
                            height: 48 * vpx
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter

                            layer.enabled: true
                            layer.effect: DropShadow {
                                horizontalOffset: 0
                                verticalOffset: 2
                                radius: 4
                                samples: 9
                                color: "#80000000"
                            }
                        }

                        Text {
                            text: modelData.name
                            color: "white"
                            font.pixelSize: 32 * vpx
                            font.bold: languageSelector.selectedIndex === index
                            anchors.verticalCenter: parent.verticalCenter

                            layer.enabled: true
                            layer.effect: DropShadow {
                                horizontalOffset: 0
                                verticalOffset: 2
                                radius: 4
                                samples: 9
                                color: "#80000000"
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: {
                            languageSelector.selectedIndex = index
                        }

                        onClicked: {
                            languageSelector.selectLanguage()
                        }
                    }
                }
            }
        }

        Text {
            text: "↑↓ Navigate  •  SPACE/ENTER Select"
            color: "#888888"
            font.pixelSize: 20 * vpx
            anchors.horizontalCenter: parent.horizontalCenter

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.4; duration: 1000 }
                NumberAnimation { to: 1.0; duration: 1000 }
            }
        }
    }

    function selectLanguage() {
        var selected = languages[selectedIndex]
        console.log("Language selected: " + selected.name + " (" + selected.code + ")")
        currentLanguage = selected.code
        languageSelected = true
        languageChosen(selected.code)
        visible = false
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Up) {
            selectedIndex = (selectedIndex - 1 + languages.length) % languages.length
            event.accepted = true
        }
        else if (event.key === Qt.Key_Down) {
            selectedIndex = (selectedIndex + 1) % languages.length
            event.accepted = true
        }
        else if (event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            selectLanguage()
            event.accepted = true
        }
        else if (api.keys && api.keys.isAccept(event)) {
            selectLanguage()
            event.accepted = true
        }
    }

    Component.onCompleted: {
        if (visible) {
            forceActiveFocus()
                console.log("Language Selector is now visible and active")
        }
    }
}
