import QtQuick 2.15

QtObject {
    id: translations

    readonly property var texts: {
        "en": {
            "gameTitle": "DINO RUNNER",
            "subtitle": "Multiple obstacles on screen!",
            "instructions": "SPACE or ↑ = Jump\n↓ = Duck (Can't hold it!)\n\nPress SPACE or BUTTON A to start",
            "score": "SCORE: ",
            "highScore": "HIGH SCORE: ",
            "gameOver": "GAME OVER!",
            "finalScore": "Score: ",
            "bestScore": "Best score: ",
            "restart": "Press SPACE or BUTTON A to restart",
            "pressSpaceFaster": "Press SPACE faster!\nThe dinosaur needs to jump on time",
            "coinObtained": "Coin obtained! Score: ",
            "collision": "COLLISION!",
            "cactusSpawned": "Cactus spawned - Type: "
        },
        "es": {
            "gameTitle": "DINO RUNNER",
            "subtitle": "¡Múltiples obstáculos en pantalla!",
            "instructions": "ESPACIO o ↑ = Saltar\n↓ = Agacharse (¡NO puedes mantenerlo!)\n\nPulsa ESPACIO o BOTÓN A para empezar",
            "score": "PUNTUACIÓN: ",
            "highScore": "RÉCORD: ",
            "gameOver": "¡GAME OVER!",
            "finalScore": "Puntuación: ",
            "bestScore": "Mejor récord: ",
            "restart": "Pulsa ESPACIO o BOTÓN A para reiniciar",
            "pressSpaceFaster": "¡Presiona ESPACIO más rápido!\nEl dinosaurio necesita saltar a tiempo",
            "coinObtained": "¡Moneda obtenida! Puntuación: ",
            "collision": "¡COLISIÓN!",
            "cactusSpawned": "Cactus spawneado - Tipo: "
        },
        "pt": {
            "gameTitle": "DINO RUNNER",
            "subtitle": "Múltiplos obstáculos na tela!",
            "instructions": "ESPAÇO ou ↑ = Pular\n↓ = Agachar (Não pode manter!)\n\nPressione ESPAÇO ou BOTÃO A para começar",
            "score": "PONTOS: ",
            "highScore": "RECORDE: ",
            "gameOver": "GAME OVER!",
            "finalScore": "Pontuação: ",
            "bestScore": "Melhor recorde: ",
            "restart": "Pressione ESPAÇO ou BOTÃO A para reiniciar",
            "pressSpaceFaster": "Pressione ESPAÇO mais rápido!\nO dinossauro precisa pular no momento certo",
            "coinObtained": "Moeda obtida! Pontuação: ",
            "collision": "COLISÃO!",
            "cactusSpawned": "Cacto gerado - Tipo: "
        },
        "fr": {
            "gameTitle": "DINO RUNNER",
            "subtitle": "Plusieurs obstacles à l'écran!",
            "instructions": "ESPACE ou ↑ = Sauter\n↓ = S'accroupir (Ne peut pas maintenir!)\n\nAppuyez sur ESPACE ou BOUTON A pour commencer",
            "score": "SCORE: ",
            "highScore": "MEILLEUR SCORE: ",
            "gameOver": "GAME OVER!",
            "finalScore": "Score: ",
            "bestScore": "Meilleur score: ",
            "restart": "Appuyez sur ESPACE ou BOUTON A pour recommencer",
            "pressSpaceFaster": "Appuyez sur ESPACE plus vite!\nLe dinosaure doit sauter à temps",
            "coinObtained": "Pièce obtenue! Score: ",
            "collision": "COLLISION!",
            "cactusSpawned": "Cactus généré - Type: "
        }
    }

    property string currentLanguage: "en"

    function t(key) {
        if (texts[currentLanguage] && texts[currentLanguage][key]) {
            return texts[currentLanguage][key]
        }
        if (texts["en"] && texts["en"][key]) {
            return texts["en"][key]
        }
        return key
    }
}
