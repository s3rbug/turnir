import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import field 1.0

ApplicationWindow {
    id: rt
    visible: true
    height: 803
    width: 1020
    minimumHeight: 803
    minimumWidth: 1020
    property int count: 9
    property int w: (width - count * space) / count
    property int h: (height - foot.height - count * space) / count
    property int rw: w * count + count * space
    property int rh: h * count + count * space
    property bool firstTime: true
    property int it: 0
    property int times: 1
    property int fontSize: 0
    property bool correct: false
    property bool modeChange: false
    property bool winChanged: false
    property int i1: 0
    property int j1: 0
    property bool checked: false
    property int maxSpeed: 0
    property int maxHeight: 0
    property int focusLength: 0
    property int batteryCharge: 0
    property int chargePerPhoto: 0
    property int chargePerMinute: 0
    property int countPhotoes: 0
    property int was: 0
    property int become: 0
    property bool skip: false
    property bool change: false
    property int chosen: 0
    property int space: 5
    property int curVal: 0
    property bool fast: false
    property bool pickStart: false
    property bool pickedStart: false
    property bool rebuild: false
    property int si: -1
    property int sj: -1
    property int ti: -1
    property int tj: -1
    property int padd: 10
    function reboot() {
        si = sj = ti = tj = -1
        pickStart = pickedStart = false
        startText.text = "Cтартове положення"
        winChanged = true
        f.clearPath()
        canva.requestPaint()
    }
    function refresh() {
        f.setInfo(maxSpeed, maxHeight, focusLength, batteryCharge,
                  chargePerPhoto, chargePerMinute, countPhotoes)
    }
    onWidthChanged: {
        firstTime = true
        winChanged = true
    }
    onHeightChanged: {
        firstTime = true
        winChanged = true
    }
    title: "Control Panel"
    Field {
        id: f
    }
    Dialog {
        id: cantFly
        Text {
            id: cantFlyText
        }
    }
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        onAccepted: {
            imgName = fileUrl
        }
    }
    Dialog {
        id: heightDialog
        contentItem: Row {
            TextField {
                id: heightText
                placeholderText: "Введіть кількість точок"
                selectByMouse: true
            }
            Button {
                id: heightOk
                text: "OK"
                onClicked: {
                    var temp = heightText.text
                    if (temp === "" || isNaN(temp))
                        trouble.open()
                    else {
                        count = temp
                        reboot()
                    }
                    heightDialog.close()
                }
            }
        }
    }
    Dialog {
        id: helpDialog
        Text {
            id: textDialog
            text: "------------------------------------------------<b>ПОЧАТОК РОБОТИ</b>--------------------------------------------------------<br>"
                  + "------------------------------------------------<b>ЗМІНА ПАРАМЕТРІВ</b>-----------------------------------------------------<br>" + "Для того, щоб змінити параметри параметри обладнання натисніть на синю кнопку з шестернею.<br>"
                  + "Після цього, виберіть необхідний параметр, введіть його значення та підтвердіть вибір.<br>" + "<b>***</b>Виберіть пункт <i>\"Фото по дорозі\"</i>, якщо Ви хочете фотографувати всі ділянкі по дорозі до кінцевої.<br>"
                  + "<b>F2</b> - зміна розмірів<br>" + "------------------------------------------------<b>РЕЖИМИ РОБОТИ</b>--------------------------------------------------------<br>"
                  + "Натискаючи на кнопку <i>\"Планування польоту\</i> та <i>\"Зміна ландшафту\"</i>, Ви змінюєте режим роботи.<br>" + "У режимі <i>\"Планування польоту\"</i> Ви маєте змогу вибрати початкову і кінцеву координату дрона.<br>"
                  + "У режимі <i>\"Зміна ландшафту\"</i> Ви можете змінювати ландшафт, обираючи його висоту<br>" + "У цьому режимі натисніть на бажану територію, щоб змінити її.<br>"
                  + "------------------------------------------------<b>ПОЧАТКОВЕ І КІНЦЕВЕ ПОЛОЖЕННЯ ДРОНА</b>------------------<br>" + "Натисніть кнопку <i>\"Стартове положення\"</i> або <i>\"Кінцеве положення\"</i>, щоб вибрати стартове і кінцеве положення.<br>"
                  + "Після вибору стартового і кінцевого положення Ви побачите маршрут польоту.<br>" + "Згодом, перед Вами буде діалогове вікно чи зберігати логи польоту.<br>"
                  + "Якщо Ви зберегли логи, то у вибраній Вами папці з\'явиться текстовий файл з логами про політ.<br>"
            font.pixelSize: 17
        }
    }
    Dialog {
        id: areUsure
        Column {
            Text {
                text: "Змінити значення з " + was + " на " + become + "?  "
            }
            CheckBox {
                checked: false
                text: "Не показувати це попередження"
                onCheckedChanged: if (checked)
                                      skip = true
            }
        }
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            if (chosen === 0)
                maxSpeed = become
            else if (chosen === 1)
                maxHeight = become
            else if (chosen === 2)
                focusLength = become
            else if (chosen === 3)
                batteryCharge = become
            else if (chosen === 4)
                chargePerPhoto = become
            else if (chosen === 5)
                chargePerMinute = become
            else
                countPhotoes = become
            refresh()
        }
    }
    MessageDialog {
        id: trouble
        icon: StandardIcon.Warning
        title: "Зверніть увагу"
        text: "Неправильний формат числових змінних. Спробуйте використовувати <b>лише</b> цифри"
    }
    FileDialog {
        id: infoPathDialog
        title: "Виберіть куди зберегти інформацію про політ"
        selectFolder: true
        onAccepted: {
            f.log(Qt.resolvedUrl(infoPathDialog.fileUrl))
        }
    }
    Dialog {
        id: infoDialog
        standardButtons: StandardButton.Yes | StandardButton.No
        Text {
            text: "Зберегти інформацію про політ?"
        }
        onYes: {
            infoPathDialog.visible = true
        }
    }
    Dialog {
        id: dialog
        title: "Виберіть параметри"

        Column {
            Row {
                TextField {
                    id: textMaxSpeed
                    placeholderText: "Максимальна швидкість(м/с)"
                    selectByMouse: true
                }
                Button {
                    text: "OK"
                    onClicked: {
                        chosen = 0
                        was = maxSpeed
                        var temp = textMaxSpeed.text
                        if (temp === "" || isNaN(temp))
                            trouble.open()
                        else {
                            become = textMaxSpeed.text
                            if (!skip)
                                areUsure.open()
                            else {
                                maxSpeed = become
                                refresh()
                            }
                        }
                        textMaxSpeed.clear()
                    }
                }
            }
            Row {
                TextField {
                    id: textMaxHeight
                    placeholderText: "Максимальна висота підйому(м)"
                    selectByMouse: true
                }
                Button {
                    text: "OK"
                    onClicked: {
                        chosen = 1
                        was = maxHeight
                        var temp = textMaxHeight.text
                        if (temp === "" || isNaN(temp))
                            trouble.open()
                        else {
                            become = textMaxHeight.text
                            if (!skip)
                                areUsure.open()
                            else {
                                maxHeight = become
                                refresh()
                            }
                        }
                        textMaxHeight.clear()


                        /* f.setInfo(maxSpeed, maxHeight, focusLength,
                                  batteryCharge, chargePerPhoto,
                                  chargePerMinute, countPhotoes)*/
                    }
                }
            }
            Row {
                TextField {
                    id: textFocusLength
                    placeholderText: "Фокусна відстань(м)"
                    selectByMouse: true
                }
                Button {
                    text: "OK"
                    onClicked: {
                        chosen = 2
                        was = focusLength
                        var temp = textFocusLength.text
                        if (temp === "" || isNaN(temp))
                            trouble.open()
                        else {
                            become = textFocusLength.text
                            if (!skip)
                                areUsure.open()
                            else {
                                focusLength = become
                                refresh()
                            }
                        }
                        textFocusLength.clear()


                        /* f.setInfo(maxSpeed, maxHeight, focusLength,
                                  batteryCharge, chargePerPhoto,
                                  chargePerMinute, countPhotoes)*/
                    }
                }
            }
            Row {
                TextField {
                    id: textBatteryCharge
                    placeholderText: "Заряд батареї (мА/хв)"
                    selectByMouse: true
                }
                Button {
                    text: "OK"
                    onClicked: {
                        chosen = 3
                        was = batteryCharge
                        var temp = textBatteryCharge.text
                        if (temp === "" || isNaN(temp))
                            trouble.open()
                        else {
                            become = textBatteryCharge.text
                            if (!skip)
                                areUsure.open()
                            else {
                                batteryCharge = become
                                refresh()
                            }
                        }
                        textBatteryCharge.clear()


                        /*f.setInfo(maxSpeed, maxHeight, focusLength,
                                  batteryCharge, chargePerPhoto,
                                  chargePerMinute, countPhotoes)*/
                    }
                }
            }
            Row {
                TextField {
                    id: textChargePerPhoto
                    placeholderText: "Витрата заряду на фото(мА)"
                    selectByMouse: true
                }
                Button {
                    text: "OK"
                    onClicked: {
                        chosen = 4
                        was = chargePerPhoto
                        var temp = textChargePerPhoto.text
                        if (temp === "" || isNaN(temp))
                            trouble.open()
                        else {
                            become = textChargePerPhoto.text
                            if (!skip)
                                areUsure.open()
                            else {
                                chargePerPhoto = become
                                refresh()
                            }
                        }
                        textChargePerPhoto.clear()


                        /*f.setInfo(maxSpeed, maxHeight, focusLength,
                                  batteryCharge, chargePerPhoto,
                                  chargePerMinute, countPhotoes)*/
                    }
                }
            }
            Row {
                TextField {
                    id: textChargePerMinute
                    placeholderText: "Заряд на хвилину польоту (мА/хв)"
                    selectByMouse: true
                }
                Button {
                    text: "OK"
                    onClicked: {
                        chosen = 5
                        was = chargePerMinute
                        var temp = textChargePerMinute.text
                        if (temp === "" || isNaN(temp))
                            trouble.open()
                        else {
                            become = textChargePerMinute.text
                            if (!skip)
                                areUsure.open()
                            else {
                                chargePerMinute = become
                                refresh()
                            }
                        }
                        textChargePerMinute.clear()


                        /*f.setInfo(maxSpeed, maxHeight, focusLength,
                                  batteryCharge, chargePerPhoto,
                                  chargePerMinute, countPhotoes)*/
                    }
                }
            }
            Row {
                TextField {
                    id: textPhotoAll
                    placeholderText: "Кількість фото"
                    selectByMouse: true
                }
                Button {
                    text: "OK"
                    onClicked: {
                        chosen = 6
                        was = countPhotoes
                        var temp = textPhotoAll.text
                        if (temp === "" || isNaN(temp))
                            trouble.open()
                        else {
                            become = textPhotoAll.text
                            if (!skip)
                                areUsure.open()
                            else {
                                countPhotoes = become
                                refresh()
                            }
                        }
                        textPhotoAll.clear()


                        /*f.setInfo(maxSpeed, maxHeight, focusLength,
                                  batteryCharge, chargePerPhoto,
                                  chargePerMinute, countPhotoes)*/
                    }
                }
            }
            CheckBox {
                id: photoAll
                text: "Фото по дорозі"
                checked: false
                onCheckedChanged: f.setPhotoAll(checked)
            }
        }
    }
    Dialog {
        id: dialogHeight
        Column {
            Text {
                id: dialText
                text: "Виберіть висоту місцевості (" + slider.value + "):"
            }
            Slider {
                id: slider
                from: 0
                to: 5000
                stepSize: 5
                value: 0
                handle: Rectangle {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    color: Qt.rgba(Math.min(slider.value / 5000, 0.4),
                                   1 - slider.value / 5000, 0)
                    radius: 13
                    implicitHeight: 26
                    implicitWidth: 26
                }
                background: Rectangle {
                    x: slider.leftPadding
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: slider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#bdbebf"

                    Rectangle {
                        width: slider.visualPosition * parent.width
                        height: parent.height
                        color: Qt.rgba(Math.min(slider.value / 5000, 0.4),
                                       1 - slider.value / 5000, 0)
                        radius: 2
                    }
                }
                onMoved: {
                    dialText.text = "Виберіть висоту місцевості (" + slider.value + "):"
                }
            }
        }
        onAccepted: {
            f.set(i1, j1, slider.value)
            //console.log(i1 + " " + j1 + " = " + slider.value)
            curVal = slider.value
            //canva.markDirty(Qt.rect(i1 * w, j1 * h, w, h))
            canva.markDirty(Qt.rect(i1 * w + i1 * space,
                                    j1 * h + j1 * space, w, h))
            //canva.markDirty(Qt.rect(i * w + i * space, j * h + j * space, w, h))
            checked = true
            slider.value = 0
            dialText.text = "Виберіть висоту місцевості (0):"
        }
    }
    footer: Row {
        height: 80
        id: foot
        width: rw
        spacing: 10
        padding: padd
        Button {
            id: mode
            Text {
                id: modeText
                text: "Планування польоту"
                height: 80 - 2 * padd
                width: parent.width
                font.pixelSize: 1000
                minimumPixelSize: 5
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                padding: padd
            }
            background: Rectangle {
                //implicitWidth: 100
                //implicitHeight: 40
                color: mode.down ? "#808080" : (mode.hovered ? "#d6d6d6" : "#f6f6f6")
                border.color: "#26282a"
                border.width: 1
                radius: padd
            }
            padding: padd
            onClicked: {
                modeChange = !modeChange
                modeText.text = modeChange ? "Зміна ландшафту" : "Планування польоту"
            }
            width: (rw - imm.width - 2 * foot.spacing - 2 * padd) / 2
            height: parent.height - 2 * padd
        }
        Button {
            id: start
            Text {
                id: startText
                text: "Cтартове положення"
                height: 80 - 2 * padd
                width: parent.width
                font.pixelSize: 1000
                minimumPixelSize: 5
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                padding: padd
            }
            background: Rectangle {
                //implicitWidth: 100
                //implicitHeight: 40
                color: start.down ? "#808080" : (start.hovered ? "#d6d6d6" : "#f6f6f6")
                border.color: "#26282a"
                border.width: 1
                radius: padd
            }
            //padding: padd
            width: (rw - imm.width - 2 * foot.spacing) / 2
            height: parent.height - 2 * padd
            onClicked: {
                if (sj === -1) {
                    ma.cursorShape = Qt.PointingHandCursor
                    pickStart = true
                } else if (tj === -1) {
                    ma.cursorShape = Qt.PointingHandCursor
                    pickedStart = true
                } else
                    reboot()
            }
        }
        Image {
            id: imm
            fillMode: Image.PreserveAspectFit
            height: parent.height - 2 * padd
            source: "qrc:/img/image/settings1.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    dialog.open()
                }
            }
        }
    }
    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        focus: true
        onFocusChanged: focus = true
        Keys.onPressed: {
            if (event.key === Qt.Key_F1) {
                //console.log("pressed")
                helpDialog.open()
                event.accepted = true
            } else if (event.key === Qt.Key_F2) {
                heightDialog.open()
                event.accepted = true
            }
        }
        onPressed: {
            if (mouse.button & Qt.RightButton) {
                fast = true
            }
            if (pressed && mouseX > 0 && mouseX <= rw && mouseY > 0
                    && mouseY <= rh) {
                var i = Math.floor(
                            mouseX / (w + space)), j = Math.floor(
                                                       mouseY / (h + space))
                var t1 = (mouseX % w - i * space), t2 = (mouseY % h - j * space)
                if ((t1 < 0 || t1 > space) && (t2 < 0 || t2 > space)) {
                    if (pickStart) {
                        si = i
                        sj = j
                        ma.cursorShape = Qt.ArrowCursor
                        startText.text = "Кінцеве положення"
                        winChanged = true
                        pickStart = false
                    }
                    if (pickedStart) {
                        ti = i
                        tj = j
                        ma.cursorShape = Qt.ArrowCursor
                        startText.text = "Новий маршрут"
                        winChanged = true
                        pickedStart = false
                        f.setCoord(si, sj, ti, tj, maxHeight, count)
                        infoDialog.visible = true
                    }
                    i1 = i
                    j1 = j

                    canva.markDirty(Qt.rect(i * w + i * space,
                                            j * h + j * space, w, h))
                }
            }
        }
    }
    Canvas {
        id: canva
        width: rt.width
        height: rt.height - foot.height
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(region)
            if (winChanged) {
                ctx.clearRect(0, 0, rt.width, rt.height)
            }
            var i = i1, j = j1, high = f.get(i, j)
            if (!fast)
                ctx.fillStyle = Qt.rgba(Math.min(high / 5000, 0.4),
                                        1 - high / 5000, 0)
            else if (!(i === si && j === sj)) {
                ctx.fillStyle = curVal
                f.set(i, j, curVal)
            }

            if (i === si && j === sj) {
                ctx.fillStyle = "blue"
                ctx.fillRect(i * w + i * space, j * h + j * space, w, h)
            } else if (i === ti && j === tj) {
                ctx.fillStyle = "yellow"
                ctx.fillRect(i * w + i * space, j * h + j * space, w, h)
            } else {
                ctx.fillRect(i * w + i * space, j * h + j * space, w, h)
            }
            ctx.fillRect(i * w + i * space, j * h + j * space, w, h)
            if (firstTime || winChanged) {
                for (var a = 0; a < count; ++a) {
                    for (var b = 0; b < count; ++b) {
                        if (a === si && b === sj) {
                            ctx.fillStyle = "blue"
                            ctx.fillRect(a * w + a * space,
                                         b * h + b * space, w, h)
                        } else if (a === ti && b === tj) {
                            ctx.fillStyle = "yellow"
                            ctx.fillRect(a * w + a * space,
                                         b * h + b * space, w, h)
                        } else {
                            var hi = f.get(a, b)
                            ctx.fillStyle = Qt.rgba(Math.min(hi / 5000, 0.4),
                                                    1 - hi / 5000, 0)
                            ctx.fillRect(a * w + a * space,
                                         b * h + b * space, w, h)
                        }
                    }
                }
                firstTime = false
            }
            if (!winChanged && modeChange && !checked && !fast) {
                slider.value = high
                dialText.text = "Виберіть висоту місцевості (" + high + "):"
                dialogHeight.open()
            }
            if (firstTime) {
                ctx.clearRect(0, 0, rt.width, rt.height)
                firstTime = false
            }
            if (ti != -1) {
                ctx.beginPath()
                ctx.lineWidth = h / 8
                ctx.lineCap = "round"
                ctx.strokeStyle = "red"
                var cnt = f.getSize()
                if (f.isReachable()) {
                    if (cnt !== 0) {
                        ctx.moveTo(si * w + si * space + w / 2,
                                   sj * h + sj * space + h / 2)
                    }

                    for (var t = 1; t < cnt; ++t) {
                        var fir = f.getPath(t, true), sec = f.getPath(t, false)
                        ctx.lineTo(fir * w + fir * space + w / 2,
                                   sec * h + sec * space + h / 2)
                    }

                    ctx.stroke()
                }
            }
            winChanged = false
            checked = false
            fast = false


            /*ctx.beginPath()
            ctx.lineWidth = 2
            ctx.lineCap = "round"
            ctx.strokeStyle = "black"
            ctx.strokeRect(-1, -1, 2 * rw, rh)*/
        }
    }
}
