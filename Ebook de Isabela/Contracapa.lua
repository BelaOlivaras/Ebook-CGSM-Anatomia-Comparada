local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = false

function scene:create(event)
    local sceneGroup = self.view
    local background = display.newImage(sceneGroup, "images/background/Contra capa.png")
    local bookCoverBtn = display.newImage(sceneGroup, "images/objects/home.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")

    background.x = display.contentCenterX
    background.y = display.contentCenterY
    bookCoverBtn.x = 100
    bookCoverBtn.y = 940
    btnVolumeOn.x = display.contentCenterX
    btnVolumeOn.y = 940
    btnVolumeOff.x = display.contentCenterX
    btnVolumeOff.y = 940
    btnVolumeOff.isVisible = false

    -- Carregar o som
    startSound = audio.loadSound("sounds/contra capa projeto cgsm.MP3")

    -- Função para tocar o som
    local function playSound()
        audio.play(startSound, { loops = -1 })
        btnVolumeOn.isVisible = true
        btnVolumeOff.isVisible = false
        isSoundOn = true
    end

    -- Função para parar o som
    local function stopSound()
        audio.stop()
        btnVolumeOn.isVisible = false
        btnVolumeOff.isVisible = true
        isSoundOn = false
    end

    -- Função para alternar entre ligar/desligar o som
    local function toggleSound()
        if isSoundOn then
            stopSound()
        else
            playSound()
        end
    end

    local function goToBookCover()
        if isSoundOn then stopSound() end
        composer.gotoScene("Capa", { effect = "fromLeft", time = 1000 })
    end

    -- Adicionar os ouvintes de eventos
    bookCoverBtn:addEventListener("tap", goToBookCover)
    btnVolumeOn:addEventListener("tap", toggleSound)
    btnVolumeOff:addEventListener("tap", toggleSound)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        if isSoundOn then
            audio.play(startSound, { loops = -1 })
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        audio.stop()
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

    if startSound then
        audio.dispose(startSound)
        startSound = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
