import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtMultimedia 5.15

Item {
    id: root
    width: 1280
    height: 720

    readonly property real vpx: Math.min(width, height) / 720
    readonly property real vpy: Math.max(width, height) / 1280

    property bool gameRunning: false
    property int score: 0
    property int highScore: api.memory.get("highScore") || 0
    property bool isDucking: false
    property int lastMilestoneScore: 0

    property real dinoJumpHeight: 180 * vpx
    property bool isJumping: false
    property real dinoBaseY: height - ground.height

    property real gameSpeed: 1.0
    property real obstacleBaseSpeed: 5.0 * vpx
    property real currentObstacleSpeed: obstacleBaseSpeed

    property int gameTime: 0
    property real minObstacleGap: 350 * vpx
    property real maxObstacleGap: 900 * vpx
    property real lastObstacleX: 0
    property int activeObstacles: 0
    property real groundTop: 0
    property real mountainSpeed: 0.3 * vpx

    property bool languageSelected: false
    property string currentLanguage: "en"
    property bool showLoadingSpinner: false

    property bool meteorActive: false
    property real meteorX: root.width + 100 * vpx
    property int meteorCurrentFrame: 0

    Translations {
        id: translations
        currentLanguage: root.currentLanguage
    }

    LanguageSelector {
        id: languageSelector
        visible: !languageSelected
        vpx: root.vpx

        onLanguageChosen: function(languageCode) {
            root.currentLanguage = languageCode
            root.languageSelected = true
            root.forceActiveFocus()
        }
    }

    SoundEffect {
        id: coinSound
        source: "assets/sound/coin.wav"
        volume: 0.5
    }

    SoundEffect {
        id: jumpSound
        source: "assets/sound/jump.wav"
        volume: 0.3
    }

    SoundEffect {
        id: dieSound
        source: "assets/sound/die.wav"
        volume: 0.3
    }

    Rectangle {
        id: skyLayer
        anchors.fill: parent
        color: "#b8dcfe"
        z: -3
    }

    Item {
        id: mountainsContainer
        width: parent.width * 4
        height: 500 * vpx
        anchors.bottom: ground.top
        x: 0
        z: 0

        Image {
            source: "assets/image/dino/Background.png"
            width: root.width
            height: parent.height
            fillMode: Image.Stretch
            x: 0
        }

        Image {
            source: "assets/image/dino/Background.png"
            width: root.width
            height: parent.height
            fillMode: Image.Stretch
            x: root.width
        }

        Image {
            source: "assets/image/dino/Background.png"
            width: root.width
            height: parent.height
            fillMode: Image.Stretch
            x: root.width * 2
        }

        Image {
            source: "assets/image/dino/Background.png"
            width: root.width
            height: parent.height
            fillMode: Image.Stretch
            x: root.width * 3
        }
    }

    Rectangle {
        id: ground
        width: parent.width
        height: 60 * vpx
        color: "transparent"
        anchors.bottom: parent.bottom
        Component.onCompleted: {
            root.groundTop = root.height - height
        }
    }

    Item {
        id: groundVisual
        width: parent.width * 3
        height: 60 * vpx
        anchors.bottom: parent.bottom
        x: 0
        z: 10

        Image {
            source: "assets/image/dino/rock.png"
            width: root.width
            height: parent.height
            fillMode: Image.TileHorizontally
            x: 0
        }

        Image {
            source: "assets/image/dino/rock.png"
            width: root.width
            height: parent.height
            fillMode: Image.TileHorizontally
            x: root.width
        }

        Image {
            source: "assets/image/dino/rock.png"
            width: root.width
            height: parent.height
            fillMode: Image.TileHorizontally
            x: root.width * 2
        }
    }

    Item {
        id: dinoContainer
        width: 70 * vpx
        height: isDucking ? 50 * vpx : 70 * vpx
        x: 150 * vpx
        anchors.bottom: root.bottom
        anchors.bottomMargin: 30 * vpx
        z: 20

        property int currentFrame: 0
        property string dinoState: "idle"

        Image {
            source: "assets/image/dino/Idle.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "idle"
        }

        Image {
            source: "assets/image/dino/Dead.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "dead"
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_1.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 0
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_2.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 1
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_3.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 2
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_4.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 3
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_5.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 4
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_6.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 5
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_7.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 6
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_8.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 7
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_9.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 8
            mipmap: true
        }

        Image {
            source: "assets/image/dino/walk/Walk_10.png"
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            visible: dinoContainer.dinoState === "running" && dinoContainer.currentFrame === 9
            mipmap: true
        }

        PropertyAnimation on anchors.bottomMargin {
            id: jumpUpAnimation
            from: 30 * vpx
            to: dinoJumpHeight + 30 * vpx
            duration: 400 / gameSpeed
            easing.type: Easing.OutQuad
            running: false
            onStarted: { playJumpSound() }
            onStopped: { fallDownAnimation.start() }
        }

        PropertyAnimation on anchors.bottomMargin {
            id: fallDownAnimation
            from: dinoJumpHeight + 30 * vpx
            to: 30 * vpx
            duration: 400 / gameSpeed
            easing.type: Easing.InQuad
            running: false
            onStopped: {
                isJumping = false
                dinoContainer.anchors.bottomMargin = 30 * vpx
            }
        }

        PropertyAnimation on height {
            id: duckAnimation
            from: 70 * vpx
            to: 50 * vpx
            duration: 100 / gameSpeed
            running: false
        }

        PropertyAnimation on height {
            id: standUpAnimation
            from: 50 * vpx
            to: 70 * vpx
            duration: 100 / gameSpeed
            running: false
        }
    }

    Item {
        id: obstaclesContainer
        anchors.fill: parent
        z: 15

        Repeater {
            id: obstacleRepeater
            model: 10

            Item {
                property bool isActive: false
                property int obstacleType: 0
                property real obstacleWidth: 50 * vpx
                property real obstacleHeight: 80 * vpx

                width: obstacleWidth
                height: obstacleHeight
                x: root.width + 100 * vpx
                visible: false
                z: 15

                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30 * vpx

                Image {
                    source: "assets/image/dino/cactus.png"
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    anchors.bottom: parent.bottom
                    visible: parent.obstacleType === 0
                }

                Image {
                    source: "assets/image/dino/cactus_doble.png"
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    anchors.bottom: parent.bottom
                    visible: parent.obstacleType === 1
                }

                Image {
                    source: "assets/image/dino/cactus_triple.png"
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    anchors.bottom: parent.bottom
                    visible: parent.obstacleType === 2
                }
            }
        }

        // Meteorito
        Item {
            id: meteorItem
            width: 90 * vpx
            height: 90 * vpx
            x: meteorX
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 120 * vpx
            visible: meteorActive
            z: 16

            Image {
                source: "assets/image/meteor/meteor_1.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 0
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_2.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 1
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_3.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 2
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_4.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 3
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_5.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 4
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_6.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 5
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_7.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 6
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_8.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 7
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_9.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 8
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_10.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 9
                mipmap: true
            }

            Image {
                source: "assets/image/meteor/meteor_11.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                visible: meteorCurrentFrame === 10
                mipmap: true
            }
        }
    }

    Text {
        text: translations.t("score") + score + "\n" + translations.t("highScore") + highScore
        color: "white"
        font.pixelSize: 28 * vpx
        font.bold: true
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20 * vpx

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 3
            radius: 8
            samples: 17
            color: "#80000000"
        }
    }

    Rectangle {
        id: startScreen
        visible: !gameRunning && !gameOverScreen.visible && languageSelected
        anchors.fill: parent
        color: "#AA222222"
        z:101

        Column {
            anchors.centerIn: parent
            spacing: 20 * vpx

            Text {
                text: translations.t("gameTitle")
                color: "white"
                font.pixelSize: 48 * vpx
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: translations.t("subtitle") + "\n\n" + translations.t("instructions")
                color: "white"
                font.pixelSize: 24 * vpx
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Rectangle {
        id: gameOverScreen
        visible: false
        anchors.fill: parent
        color: "#AA000000"
        z:100

        Column {
            anchors.centerIn: parent
            spacing: 30 * vpx

            Text {
                text: translations.t("gameOver")
                color: "#FF5555"
                font.pixelSize: 48 * vpx
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: translations.t("finalScore") + score + "\n" + translations.t("bestScore") + highScore
                color: "white"
                font.pixelSize: 32 * vpx
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: root.width
                height: 80 * vpx
                anchors.horizontalCenter: parent.horizontalCenter
                visible: showLoadingSpinner

                Rectangle {
                    anchors.fill: parent
                    color: "#282828"
                }

                Item {
                    id: loadingSpinner
                    width: 80 * vpx
                    height: 80 * vpx
                    anchors.centerIn: parent

                    property int currentFrame: 0

                    Image {
                        source: "assets/image/loading/loading_1.png"
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        visible: loadingSpinner.currentFrame === 0
                    }

                    Image {
                        source: "assets/image/loading/loading_2.png"
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        visible: loadingSpinner.currentFrame === 1
                    }

                    Image {
                        source: "assets/image/loading/loading_3.png"
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        visible: loadingSpinner.currentFrame === 2
                    }

                    Image {
                        source: "assets/image/loading/loading_4.png"
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        visible: loadingSpinner.currentFrame === 3
                    }

                    Timer {
                        interval: 150
                        running: showLoadingSpinner
                        repeat: true
                        onTriggered: {
                            loadingSpinner.currentFrame = (loadingSpinner.currentFrame + 1) % 4
                        }
                    }
                }
            }

            Text {
                text: score === 0 ? translations.t("pressSpaceFaster") : translations.t("restart")
                color: "#AAAAAA"
                font.pixelSize: 24 * vpx
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !showLoadingSpinner
            }
        }
    }

    Timer {
        interval: 50
        running: gameRunning && dinoContainer.dinoState === "running" && !isJumping
        repeat: true
        onTriggered: {
            dinoContainer.currentFrame = (dinoContainer.currentFrame + 1) % 10
        }
    }

    Timer {
        interval: 100
        running: gameRunning
        repeat: true
        onTriggered: {
            score++
            if (score > 0 && score % 100 === 0 && score !== lastMilestoneScore) {
                lastMilestoneScore = score
                playCoinSound()
            }
            if (score % 100 === 0) increaseGameSpeed()
                if (score % 500 === 0) increaseGameSpeed()
                    if (score > 300 && score % 50 === 0) increaseGameSpeed(0.02)
        }
    }

    Timer {
        interval: 1000
        running: gameRunning
        repeat: true
        onTriggered: {
            gameTime++
            if (gameTime >= 20) adjustObstacleGap()
        }
    }

    Timer {
        interval: 16
        running: gameRunning
        repeat: true
        onTriggered: {
            updateObstacles()
            updateMeteor()
            checkCollisions()
            checkSpawnNewObstacle()
            checkSpawnMeteor()
        }
    }

    Timer {
        id: duckTimer
        interval: 200 / gameSpeed
        running: false
        repeat: false
        onTriggered: {
            if (isDucking) stopDucking()
        }
    }

    Timer {
        interval: 16
        running: gameRunning
        repeat: true
        onTriggered: {
            updateGround()
            updateMountains()
        }
    }

    Timer {
        id: loadingSpinnerTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            showLoadingSpinner = false
        }
    }

    Timer {
        id: meteorAnimationTimer
        interval: 50
        running: meteorActive
        repeat: true
        onTriggered: {
            meteorCurrentFrame = (meteorCurrentFrame + 1) % 11
        }
    }

    function playCoinSound() {
        if (coinSound && coinSound.source) {
            console.log(translations.t("coinObtained") + score)
            coinSound.play()
        }
    }

    function playJumpSound() {
        if (jumpSound && jumpSound.source && gameRunning) jumpSound.play()
    }

    function playDieSound() {
        if (dieSound && dieSound.source) dieSound.play()
    }

    function jump() {
        if (gameRunning && !isJumping && !isDucking) {
            isJumping = true
            jumpUpAnimation.duration = 400 / gameSpeed
            jumpUpAnimation.start()
        }
    }

    function duck() {
        if (gameRunning && !isJumping && !isDucking) {
            isDucking = true
            duckAnimation.duration = 100 / gameSpeed
            duckAnimation.start()
            duckTimer.interval = 200 / gameSpeed
            duckTimer.start()
        }
    }

    function stopDucking() {
        if (gameRunning && isDucking) {
            isDucking = false
            duckTimer.stop()
            standUpAnimation.duration = 100 / gameSpeed
            standUpAnimation.start()
        }
    }

    function startGame() {
        gameRunning = true
        score = 0
        lastMilestoneScore = 0
        gameTime = 0
        activeObstacles = 0
        lastObstacleX = root.width
        gameSpeed = 1.0
        mountainSpeed = 0.3 * vpx
        currentObstacleSpeed = obstacleBaseSpeed * gameSpeed
        minObstacleGap = 350 * vpx
        maxObstacleGap = 900 * vpx
        isJumping = false
        isDucking = false
        showLoadingSpinner = false
        loadingSpinnerTimer.stop()
        gameOverScreen.visible = false
        jumpUpAnimation.stop()
        fallDownAnimation.stop()
        duckTimer.stop()
        dinoContainer.height = 70 * vpx
        dinoContainer.anchors.bottomMargin = 30 * vpx
        dinoContainer.dinoState = "running"
        dinoContainer.currentFrame = 0

        meteorActive = false
        meteorX = root.width + 100 * vpx
        meteorCurrentFrame = 0

        for (var i = 0; i < obstacleRepeater.count; i++) {
            var obstacle = obstacleRepeater.itemAt(i)
            obstacle.isActive = false
            obstacle.visible = false
            obstacle.x = root.width + 100 * vpx
        }

        groundVisual.x = 0
        mountainsContainer.x = 0
        spawnNewObstacle()
    }

    function gameOver() {
        gameRunning = false
        duckTimer.stop()
        playDieSound()
        dinoContainer.dinoState = "dead"

        if (score > highScore) {
            highScore = score
            api.memory.set("highScore", highScore)
        }

        showLoadingSpinner = true
        loadingSpinnerTimer.start()
        gameOverScreen.visible = true
    }

    function increaseGameSpeed(increment) {
        if (!increment) increment = 0.1
            if (gameSpeed < 3.0) {
                gameSpeed = Math.min(gameSpeed + increment, 3.0)
                mountainSpeed = 0.3 * gameSpeed * vpx
                currentObstacleSpeed = obstacleBaseSpeed * gameSpeed
                minObstacleGap = Math.max(350 * vpx - (gameSpeed - 1.0) * 80 * vpx, 200 * vpx)
                maxObstacleGap = Math.max(900 * vpx - (gameSpeed - 1.0) * 200 * vpx, 500 * vpx)
                jumpUpAnimation.duration = 400 / gameSpeed
                fallDownAnimation.duration = 400 / gameSpeed
                duckAnimation.duration = 100 / gameSpeed
                standUpAnimation.duration = 100 / gameSpeed
            }
    }

    function adjustObstacleGap() {
        var randomFactor = Math.random()
        if (randomFactor < 0.3) {
            minObstacleGap = 200 * vpx + Math.random() * 100 * vpx
            maxObstacleGap = 400 * vpx + Math.random() * 100 * vpx
        } else if (randomFactor < 0.7) {
            minObstacleGap = 300 * vpx + Math.random() * 150 * vpx
            maxObstacleGap = 600 * vpx + Math.random() * 150 * vpx
        } else {
            minObstacleGap = 500 * vpx + Math.random() * 200 * vpx
            maxObstacleGap = 800 * vpx + Math.random() * 200 * vpx
        }
    }

    function updateObstacles() {
        if (!gameRunning) return
            activeObstacles = 0
            var rightmostX = -1000 * vpx

            for (var i = 0; i < obstacleRepeater.count; i++) {
                var obstacle = obstacleRepeater.itemAt(i)
                if (obstacle.isActive && obstacle.visible) {
                    obstacle.x -= currentObstacleSpeed
                    activeObstacles++
                    if (obstacle.x > rightmostX) rightmostX = obstacle.x
                        if (obstacle.x < -obstacle.width - 50 * vpx) {
                            obstacle.isActive = false
                            obstacle.visible = false
                        }
                }
            }
            if (rightmostX > -1000 * vpx) lastObstacleX = rightmostX
    }

    function checkSpawnNewObstacle() {
        if (!gameRunning) return
            var distanceFromLast = root.width - lastObstacleX
            var gapRange = maxObstacleGap - minObstacleGap
            var randomGap = minObstacleGap + (Math.random() * gapRange)
            if (gameTime >= 20) {
                var surpriseFactor = 0.85 + (Math.random() * 0.3)
                randomGap *= surpriseFactor
            }
            if (distanceFromLast > randomGap) spawnNewObstacle()
    }

    function spawnNewObstacle() {
        if (!gameRunning) return
            for (var i = 0; i < obstacleRepeater.count; i++) {
                var obstacle = obstacleRepeater.itemAt(i)
                if (!obstacle.isActive) {
                    var randomValue = Math.random()
                    var selectedType = 0
                    var newWidth = 50 * vpx
                    var newHeight = 80 * vpx
                    var tripleChance = 0.15 + (gameSpeed - 1.0) * 0.08
                    var doubleChance = 0.35 + (gameSpeed - 1.0) * 0.10

                    if (randomValue < tripleChance) {
                        selectedType = 2
                        newWidth = 120 * vpx
                        newHeight = 95 * vpx
                    } else if (randomValue < tripleChance + doubleChance) {
                        selectedType = 1
                        newWidth = 75 * vpx
                        newHeight = 80 * vpx
                    } else {
                        selectedType = 0
                        newWidth = 50 * vpx
                        if (Math.random() > 0.6) {
                            newHeight = 65 * vpx + Math.random() * 30 * vpx
                        } else {
                            newHeight = 80 * vpx
                        }
                    }

                    obstacle.obstacleType = selectedType
                    obstacle.obstacleWidth = newWidth
                    obstacle.obstacleHeight = newHeight
                    obstacle.width = newWidth
                    obstacle.height = newHeight
                    obstacle.x = root.width
                    obstacle.isActive = true
                    obstacle.visible = true
                    lastObstacleX = root.width
                    console.log(translations.t("cactusSpawned") + selectedType + ", Width: " + newWidth + ", Height: " + newHeight)
                    break
                }
            }
    }

    function checkCollisions() {
        if (!gameRunning) return
            var dinoLeft = dinoContainer.x
            var dinoRight = dinoContainer.x + dinoContainer.width
            var dinoTop = ground.y - dinoContainer.height - dinoContainer.anchors.bottomMargin
            var dinoBottom = ground.y - dinoContainer.anchors.bottomMargin

            // Colisión con cactus (solo si no está saltando)
            if (!isJumping) {
                for (var i = 0; i < obstacleRepeater.count; i++) {
                    var obstacle = obstacleRepeater.itemAt(i)
                    if (obstacle.isActive && obstacle.visible) {
                        var obstacleLeft = obstacle.x
                        var obstacleRight = obstacle.x + obstacle.width
                        var obstacleTop = obstacle.y
                        var obstacleBottom = obstacle.y + obstacle.height
                        var horizontalCollision = (dinoRight > obstacleLeft + 15 * vpx) && (dinoLeft < obstacleRight - 15 * vpx)
                        var verticalCollision = (dinoBottom > obstacleTop + 10 * vpx)

                        if (horizontalCollision && verticalCollision) {
                            gameOver()
                            console.log(translations.t("collision"))
                            return
                        }
                    }
                }
            }

            // Colisión con meteorito (solo si NO está agachado)
            if (meteorActive && !isDucking) {
                var meteorLeft = meteorX
                var meteorRight = meteorX + meteorItem.width
                var meteorTopY = ground.y - meteorItem.anchors.bottomMargin - meteorItem.height
                var meteorBottomY = ground.y - meteorItem.anchors.bottomMargin

                var meteorHorizontalCollision = (dinoRight > meteorLeft + 20 * vpx) && (dinoLeft < meteorRight - 20 * vpx)
                var meteorVerticalCollision = (dinoTop < meteorBottomY - 10 * vpx)

                if (meteorHorizontalCollision && meteorVerticalCollision) {
                    gameOver()
                    console.log("===== COLLISION WITH METEOR! =====")
                    return
                }
            }
    }

    function updateGround() {
        if (!gameRunning) return
            groundVisual.x -= currentObstacleSpeed
            if (groundVisual.x <= -root.width) groundVisual.x = 0
    }

    function updateMountains() {
        if (!gameRunning) return
            mountainsContainer.x -= mountainSpeed
            if (mountainsContainer.x <= -root.width) mountainsContainer.x = 0
    }

    function updateMeteor() {
        if (!gameRunning || !meteorActive) return
            meteorX -= currentObstacleSpeed * 1.2
            if (meteorX < -meteorItem.width - 50 * vpx) {
                meteorActive = false
                meteorX = root.width + 100 * vpx
            }
    }

    function checkSpawnMeteor() {
        if (!gameRunning || meteorActive || score < 25) return

            // Verificar que no haya cactus cerca
            var hasNearbyObstacle = false
            for (var i = 0; i < obstacleRepeater.count; i++) {
                var obstacle = obstacleRepeater.itemAt(i)
                if (obstacle.isActive && obstacle.visible) {
                    var distanceToObstacle = Math.abs(obstacle.x - root.width)
                    if (distanceToObstacle < 400 * vpx) {
                        hasNearbyObstacle = true
                        break
                    }
                }
            }

            if (!hasNearbyObstacle) {
                var spawnChance = Math.random()
                // Aumenté la probabilidad para que sea más fácil de ver
                if (spawnChance < 0.015) {
                    meteorActive = true
                    meteorX = root.width + 100 * vpx
                    meteorCurrentFrame = 0
                    console.log("===== METEOR SPAWNED at score: " + score + " =====")
                }
            }
    }

    focus: true

    Keys.onPressed: {
        if (languageSelector.visible) {
            languageSelector.Keys.onPressed(event)
            event.accepted = true
            return
        }

        if (event.isAutoRepeat) {
            event.accepted = true
            return
        }

        if (event.key === 32 || event.key === Qt.Key_Space || event.key === Qt.Key_Up) {
            if (!gameRunning && !showLoadingSpinner) {
                startGame()
            } else if (gameRunning) {
                jump()
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Down) {
            if (gameRunning) {
                duck()
                event.accepted = true
            }
        }
        else if (api.keys.isAccept(event)) {
            if (!gameRunning && !showLoadingSpinner) {
                startGame()
            } else if (gameRunning) {
                jump()
            }
            event.accepted = true
        }
        else if (api.keys.isCancel(event)) {
            if (gameRunning) {
                duck()
            }
            event.accepted = true
        }
    }

    Keys.onReleased: {
        if (event.isAutoRepeat) {
            event.accepted = true
            return
        }
        if (event.key === Qt.Key_Down || (api.keys && api.keys.isCancel && api.keys.isCancel(event))) {
            stopDucking()
        }
    }

    Component.onCompleted: {
        console.log("=== DINO RUNNER - Language System ===")
        console.log("Screen size: " + width + "x" + height)
        console.log("Language selector will be shown on every startup")
        languageSelected = false
        dinoContainer.dinoState = "idle"
    }
}
