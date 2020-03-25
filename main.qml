import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Fergos Incomplete LAKKA MAME2003PLUS Playlist Magic")

    property var jsonGames
    property var dictX: {"none":"none"}

    property var xmlSourceFile: "qrc:/MAME 2003-Plus_Example.xml"
    property var jsonSourceFile: "qrc:/MAME 2003-Plus_LakkaPlaylist.json"

    XmlListModel {
        id: xmlModel
        source: "qrc:/MAME 2003-Plus_Example.xml"
        query: "/mame/game"

        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "name"; query: "@name/string()" }
    }

    ListView {
        id: xmlGameList
        opacity: 0.45
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width*0.5
        height: parent.height*0.9
        model: xmlModel
        delegate: Text { text: name + " : " + description; font.pixelSize: { return xmlGameList.height*0.025 } }
    }

    Flickable {
        id: finalTextFlickable
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height*0.9
        width: parent.width*0.45
        contentWidth: width; contentHeight: finalText.height

        Text {
            id: finalText
            text: "Waiting For Data!!!"
            font.pixelSize: { return finalTextFlickable.height*0.025 }
        }
    }

    Rectangle {
        id: justWhiteTop
        width: parent.width
        height: parent.height*0.1
        color: "white"
    }

    TextEdit {
        id: outputText
        text: finalText.text
        visible: false
    }

    Rectangle {
        id: justWhiteBottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height*0.1
        color: "white"
    }

    Rectangle {
        id: chooseXML
        anchors.left: xmlGameList.left
        anchors.bottom: xmlGameList.top
        width: xmlGameList.width*0.3
        height: parent.height*0.1*0.9
        anchors.bottomMargin: parent.height*0.1*0.1*0.5
        anchors.leftMargin: anchors.bottomMargin
        radius: height*0.1
        color: "lightgreen"

        Text {
            id: xmlButtonText
            text: qsTr("Pick XML File")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: parent.height*0.3
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: chooseXML.color = "green"
            onExited: chooseXML.color = "lightgreen"
            onClicked: {
                fileXMLDialog.open()
            }
        }
    }

    Text {
        id: currentXMLFilePath
        text: xmlSourceFile
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WrapAnywhere
        anchors.left: chooseXML.right
        anchors.bottom: xmlGameList.top
        anchors.leftMargin: (xmlGameList.width-chooseXML.width)*0.05
        anchors.bottomMargin: chooseXML.bottomMargin
        height: parent.height*0.1
        width: (xmlGameList.width-chooseXML.width)*0.9
        font.pixelSize: { return xmlButtonText.font.pixelSize*0.5 }
    }

    Rectangle {
        id: chooseJson
        anchors.left: finalTextFlickable.left
        anchors.bottom: finalTextFlickable.top
        width: finalTextFlickable.width*0.3
        height: parent.height*0.1*0.9
        anchors.bottomMargin: parent.height*0.1*0.1*0.5
        anchors.leftMargin: anchors.bottomMargin
        radius: height*0.1
        color: "lightblue"

        Text {
            id: jsonButtonText
            text: qsTr("Pick JSON File")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: parent.height*0.3
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: chooseJson.color = "blue"
            onExited: chooseJson.color = "lightblue"
            onClicked: {
                fileJsonDialog.open()
            }
        }
    }

    Rectangle {
        id: copyJson
        anchors.left: finalTextFlickable.left
        anchors.top: justWhiteBottom.top
        width: finalTextFlickable.width*0.3
        height: parent.height*0.1*0.9
        anchors.topMargin: parent.height*0.1*0.1*0.5
        anchors.leftMargin: anchors.topMargin
        radius: height*0.1
        color: "lightblue"

        Text {
            id: jsonCopyButtonText
            text: qsTr("Copy JSON to Clipboard")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            wrapMode: Text.WordWrap
            color: "white"
            font.pixelSize: parent.height*0.3
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: copyJson.color = "blue"
            onExited: copyJson.color = "lightblue"
            onClicked: {
                outputText.selectAll()
                outputText.copy()
            }
        }
    }

    Rectangle {
        id: againButton
        anchors.left: copyJson.right
        anchors.top: justWhiteBottom.top
        width: finalTextFlickable.width*0.3
        height: parent.height*0.1*0.9
        anchors.topMargin: parent.height*0.1*0.1*0.5
        anchors.leftMargin: anchors.topMargin
        radius: height*0.1
        color: "lightgrey"

        Text {
            id: againButtonText
            text: qsTr("Again!")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            wrapMode: Text.WordWrap
            color: "white"
            font.pixelSize: parent.height*0.3
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: againButton.color = "grey"
            onExited: againButton.color = "lightgrey"
            onClicked: {
                loadingCover.visible = true
                loadingCover.enabled = true
                xmlModel.reload()
                xmlModel.source = xmlSourceFile
                xmlLoadCheck.start()
            }
        }
    }

    Text {
        id: currentJsonFilePath
        text: jsonSourceFile
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WrapAnywhere
        anchors.left: chooseJson.right
        anchors.bottom: finalTextFlickable.top
        anchors.leftMargin: (finalTextFlickable.width-chooseJson.width)*0.05
        //anchors.bottomMargin: chooseJson.bottomMargin
        height: parent.height*0.1
        width: (finalTextFlickable.width-chooseJson.width)*0.9
        font.pixelSize: { return xmlButtonText.font.pixelSize*0.5 }//wow
    }

    Timer {
         id: xmlLoadCheck
         interval: 1000; running: true; repeat: true
         onTriggered: testXMLload()
    }

    Rectangle {
        id: loadingCover
        anchors.fill: parent
        color: "grey"
        opacity: 0.9
        enabled: true
        visible: true
        Text {
            id: loading
            color: "white"
            anchors.fill: parent
            text: qsTr("Please Wait Loading!")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: { return loadingCover.height*0.1 }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {}
            onExited: {}
            onClicked: {}
        }
    }

    FileDialog {
        id: fileXMLDialog
        title: "Please choose a XML file"
        folder: shortcuts.home
        onAccepted: {
            console.log("You chose: " + fileXMLDialog.fileUrls)
            xmlSourceFile = fileXMLDialog.fileUrl
            fileXMLDialog.close()
        }
        onRejected: {
            console.log("Canceled")
            fileXMLDialog.close()
        }
        Component.onCompleted: visible = false
    }

    FileDialog {
        id: fileJsonDialog
        title: "Please a JSON file"
        folder: shortcuts.home
        onAccepted: {
            console.log("You chose: " + fileJsonDialog.fileUrls)
            jsonSourceFile = fileJsonDialog.fileUrl
            fileJsonDialog.close()
        }
        onRejected: {
            console.log("Canceled")
            fileJsonDialog.close()
        }
        Component.onCompleted: visible = false
    }

    function openJson() {
        var JsonString = openFile(jsonSourceFile);
        jsonGames= JSON.parse(JsonString);
        console.log("Json version: " + jsonGames.version)
        console.log("Json Size: " + jsonGames.items.length)
    }

    function saveJson() {
        var jsonSaveString = JSON.stringify(jsonGames, undefined, 2);
        console.log("-------------------------")
        console.log("result:" + jsonSaveString.length)
        finalText.text = jsonSaveString
    }

    function fixNames() {
        console.log("fixNames START")
        for (var i = 0; i < jsonGames.items.length; i++) {
            var cName =  jsonGames.items[i].label
            var getName = dictX[cName]
            console.log("Get from dict item " + i + " ("+cName+") = " + getName + (String(getName) === String("undefined") ? " NOT OK NOT $$$$$$$$$$$$$$$$$" : "***"))
            if (String(getName) !== String("undefined")) {
                jsonGames.items[i].label = getName
            }
        }
        console.log("fixNames END")
    }

    function testXMLload() {
        if (xmlModel.status == XmlListModel.Null) {
            console.log("Teste (NULL) = " + xmlModel.status)
        } else if (xmlModel.status == XmlListModel.Ready) {
            console.log("Teste (Ready) = " + xmlModel.status)
            xmlLoadCheck.stop()
            createDict()
            openJson()
            fixNames()
            saveJson()
            loadingCover.visible = false
            loadingCover.enabled = false
        } else if (xmlModel.status == XmlListModel.Loading) {
            console.log("Teste (Loading) = " + xmlModel.status)
        } else if (xmlModel.status == XmlListModel.Error) {
            console.log("Teste (Error) = " + xmlModel.status + " ||| Message: " + xmlModel.errorString())
        }
    }

    function createDict() {
        console.log("createDict START")
        for (var i = 0; i < xmlModel.count; i++) {
            var t = xmlModel.get(i)
            dictX[t.name] = t.description
            console.log("createDict Entry("+ i +"): "+ t.name + " = " + t.description)
        }
        console.log("createDict test : " + dictX["puckman"])
        console.log("createDict End")
    }

    function openFile(fileUrl) {
        var request = new XMLHttpRequest();
        request.open("GET", fileUrl, false);
        request.send(null);
        return request.responseText;
    }
}
