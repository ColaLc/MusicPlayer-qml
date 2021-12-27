import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQml.Models 2.15

Item {
    property int fontSize: 18
    property string fontColor: "#202020"

    ListModel {
        id: myModel
    }

    Rectangle {
        anchors.fill: parent
        color: '#F0E68C'
        ListView {
            anchors.fill: parent
            id: myListView
            header: Rectangle {
                width: parent.width
                height: 50
                color: "#F8F8FF"
                border.color: '#DCDCDC'
                border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 1
                    spacing: 0
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumWidth: 40
                        color: "transparent "
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                            font.bold: true
                            text: ""
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent "
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                            font.bold: true
                            text: "歌曲"
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent "
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                            font.bold: true
                            text: "歌手"
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumWidth: 80
                        color: "transparent "
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                            font.bold: true
                            text: "时间"
                        }
                    }
                }
            }
            model: myModel
            delegate: Rectangle {
                id: myDeleg
                width: parent.width
                height: 40
                color: Qt.rgba(0, 0, 0, 0)
                RowLayout {
                    anchors.fill: parent
                    spacing: 0
                    Rectangle {
                        //歌曲序列号
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumWidth: 40
                        color: Qt.rgba(0, 0, 0, 0)
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: fontSize
                            font.bold: true
                            text: index + 1
                            color: fontColor
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Qt.rgba(0, 0, 0, 0)
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: name
                            font.pixelSize: fontSize
                            font.bold: true
                            color: fontColor
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        color: Qt.rgba(0, 0, 0, 0)
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: fontColor
                            text: author
                            font.pixelSize: fontSize
                            font.bold: true
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Qt.rgba(0, 0, 0, 0)
                        Layout.maximumWidth: 80
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: fontColor
                            text: totalTime
                            font.pixelSize: fontSize
                            font.bold: true
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        parent.color = 'gray'
                    }
                    onExited: {
                        if (myListView.currentIndex === index) {
                            parent.color = 'lightgray'
                        } else {
                            parent.color = 'transparent'
                        }
                    }
                    onClicked: {

                    }
                    onDoubleClicked: {
                        musicPlayer.setCurrentMusicIndex(index)
                        musicPlayer.startPlay()
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        musicPlayer.addMusicInfo.connect(addList)
        musicPlayer.currentListIndex_Signal.connect(setCurrentIndexColor)
    }

    //*********设置当前index背景色***********//
    function setCurrentIndexColor(value) {
        myListView.currentItem.color = "transparent"
        myListView.currentIndex = value
        myListView.currentItem.color = "lightgray"
    }

    //*********添加list***********//
    function addList(title, author, time) {
        myModel.append({
                           "name": title,
                           "author": author,
                           "totalTime": time
                       })
    }
}
