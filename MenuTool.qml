//***********界面下方控制栏************//
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

Rectangle {
    property int size: 60
    color: '#E0FFFF'

    //********图片区域*********//
    Row {
        anchors.verticalCenter: parent.verticalCenter
        Rectangle {
            width: 300
            height: parent.height
            anchors.left: parent.left
            Image {
                id: imageRec
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                height: 80
                width: 80
                cache: false
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: "pic/music.png"

                Component.onCompleted: {
                    musicPlayer.callQmlRefeshImg.connect(function refe() {
                        imageRec.source = ""
                        imageRec.source = "image://myImage"
                        titleText.text = musicPlayer.currMusicTitle
                        authorText.text = musicPlayer.currMusicAuthor
                    })
                }
            }
            Column {
                anchors.left: imageRec.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20
                Text {
                    id: titleText
                    font.pixelSize: 12
                }
                Text {
                    id: authorText
                    font.pixelSize: 12
                }
            }
        }
    }
    //*****播放按钮******//
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        height: parent.height
        spacing: 30

        Rectangle {
            id: playModeImageRect
            width: 50
            height: 50
            color: 'transparent'
            state: "name1"
            Image {
                id: playModeImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
            states: [
                State {
                    name: "name1"
                    PropertyChanges {
                        target: playModeImage
                        source: "pic/1.png"
                    }
                },
                State {
                    name: "name2"
                    PropertyChanges {
                        target: playModeImage
                        source: "pic/2.png"
                    }
                },
                State {
                    name: "name3"
                    PropertyChanges {
                        target: playModeImage
                        source: "pic/3.png"
                    }
                },
                State {
                    name: "name4"
                    PropertyChanges {
                        target: playModeImage
                        source: "pic/4.png"
                    }
                }
            ]
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (playModeImageRect.state === "name1") {
                        playModeImageRect.state = "name2"
                        musicPlayer.setPlayMode(3)
                    } else if (playModeImageRect.state === "name2") {
                        playModeImageRect.state = "name3"
                        musicPlayer.setPlayMode(1)
                    } else if (playModeImageRect.state == "name3") {
                        playModeImageRect.state = "name4"
                        musicPlayer.setPlayMode(4)
                    } else if (playModeImageRect.state == "name4") {
                        playModeImageRect.state = "name1"
                        musicPlayer.setPlayMode(2)
                    } else {
                        playModeImageRect.state = "name1"
                        musicPlayer.setPlayMode(2)
                    }
                }
            }
        }

        //*********上一曲btn********//
        Rectangle {
            width: size
            height: size
            color: 'transparent '
            radius: size
            Image {
                anchors.fill: parent
                source: "pic/previous.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = 'gray'
                }
                onExited: {
                    parent.color = 'transparent '
                }
                onClicked: {
                    musicPlayer.setPreviousMusic()
                }
            }
        }

        //*********播放btn********//
        Rectangle {
            id: startBtn
            width: size
            height: size
            radius: size
            color: "transparent "
            property bool flagBtn: true

            Image {
                anchors.fill: parent
                source: startBtn.flagBtn ? "pic/pause.png" : "pic/stop.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = 'gray'
                }
                onExited: {
                    parent.color = 'transparent '
                }
                onClicked: {
                    if (startBtn.flagBtn) {
                        startBtn.flagBtn = !startBtn.flagBtn
                        musicPlayer.startPlay()
                    } else {
                        startBtn.flagBtn = !startBtn.flagBtn
                        musicPlayer.stopPlay()
                    }
                }
            }
        }

        //*********下一曲btn********//
        Rectangle {
            id: right
            width: size
            height: size
            color: 'transparent '
            radius: size
            Image {
                anchors.fill: parent
                source: "pic/next.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = 'gray'
                }
                onExited: {
                    parent.color = 'transparent '
                }
                onClicked: {
                    musicPlayer.setNextMusic()
                }
            }
        }
    }
    //*****进度条******//
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        height: 60
        //*********进度滚动条********//
        Rectangle {
            id: durationSlider
            width: 450
            height: parent.height
            color: 'transparent'
            Row {
                anchors.fill: parent
                Text {
                    id: currDuration
                    width: size
                    height: parent.height
                    text: musicPlayer ? musicPlayer.currPostion : null
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Slider {
                    id: control
                    width: parent.width - size * 2
                    height: size
                    from: 0
                    value: 0
                    to: 100

                    handle: Rectangle {
                        x: control.leftPadding + control.visualPosition
                           * (control.availableWidth - width)
                        y: control.topPadding + control.availableHeight / 2 - height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 5
                        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                    background: Rectangle {
                        x: control.leftPadding
                        y: control.topPadding + control.availableHeight / 2 - height / 2
                        implicitWidth: parent.width
                        implicitHeight: 8
                        width: control.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: "#bdbebf"
                        Rectangle {
                            width: control.visualPosition * parent.width
                            height: parent.height
                            color: "#DC143C"
                            radius: 2
                        }
                    }
                    onMoved: {
                        musicPlayer.setCurrentDuration(value)
                    }

                    Component.onCompleted: {

                        musicPlayer.musicDurationChanged.connect(setValue)
                    }
                    function setValue(vloumValue) {
                        value = vloumValue
                    }
                }
                Text {
                    id: totalduration
                    width: size
                    height: parent.height
                    text: musicPlayer ? musicPlayer.currMusicToalTime : null
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
    //*****音量区域******//
    Row {
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20

        //*********音量btn********//
        Rectangle {
            id: volumBtn
            width: size - 10
            height: size - 10
            color: 'transparent'
            radius: size
            Image {
                id: volueImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: "pic/volum.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    popup.open()
                }
                onEntered: {
                    parent.color = 'gray'
                }
                onExited: {
                    parent.color = 'transparent '
                }
            }

           //**********音量滚动条  Slider*************//
            Rectangle {
                width: 50
                height: 120
                color: 'transparent'
                anchors.bottom: parent.top
                Popup {
                    id: popup
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    background: Slider {
                        id: volumSlider
                        //anchors.centerIn: parent
                        anchors.fill: parent
                        orientation: Qt.Vertical
                        from: 0
                        to: 100
                        value: 50
                        handle: Rectangle {
                            x: parent.bottomPadding + parent.availableWidth / 2 - width / 2
                            y: parent.leftPadding + parent.visualPosition
                               * (parent.availableHeight - height)
                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 4
                            color: parent.pressed ? "#f0f0f0" : "#f6f6f6"
                            border.color: "#bdbebf"
                        }
                        background: Rectangle {
                            x: parent.bottomPadding + parent.availableWidth / 2 - width / 2
                            y: parent.bottomPadding
                            implicitWidth: 8
                            implicitHeight: parent.height
                            width: 8
                            height: volumSlider.availableHeight
                            radius: 4
                            color: "#bdbebf"
                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: parent.height - volumSlider.visualPosition * parent.height
                                color: "#DC143C"
                                radius: 2

                            }
                        }

                        onValueChanged: {
                            musicPlayer.setVolum(value)
                            if (value === 0)
                                volueImage.source = "pic/silence.png"
                            else
                                volueImage.source = "pic/volum.png"
                        }
                    }
                }
            }
        }

        //********* openfile btn ********//
        Rectangle {
            id: openfile
            width: size
            height: size
            radius: size
            color: 'transparent'
            Image {
                anchors.fill: parent
                source: "pic/folder.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    fileDialog.open()
                }
                onEntered: {
                    parent.color = "gray"
                }
                onExited: {
                    parent.color = "transparent"
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFiles
        title: qsTr("Open file")
        nameFilters: [qsTr("MP3 files (*.mp3)"), qsTr("All files (*.*)")]
        onAccepted: {
            musicPlayer.setMusicList(fileDialog.files)
        }
    }
}
