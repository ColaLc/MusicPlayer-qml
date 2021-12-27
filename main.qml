import QtQuick 2.15
import QtQuick.Window 2.15
import MyMusicPlayClass 1.0
import QtQuick.Layouts 1.15

Window {
    width: 850
    height: 800
    minimumWidth: 850
    minimumHeight: 300
    visible: true
    title: qsTr("Music Play")

    ColumnLayout{
        anchors.fill: parent
        spacing: 1

        PlayList{
            Layout.fillWidth: true
            Layout.fillHeight: true
            height: 5

        }
        Rectangle{
            Layout.fillWidth: true
            //Layout.fillHeight: true
            height: 120
            //height: 1
            border.width: 1
            border.color: 'gray'

            MenuTool{
                anchors.fill: parent
                anchors.topMargin: 1
            }
        }

        MyMusicPlayObj{
            id:musicPlayer
        }
    }
}
