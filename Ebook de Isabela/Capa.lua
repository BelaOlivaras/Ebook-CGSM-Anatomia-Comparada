local composer = require("composer")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Carregar o som localmente
    local startSound = audio.loadSound("sounds/Capa audio projeto cgsm.MP3")
    local isSoundOn = false

    -- Botões e objetos de cena
    local background = display.newImage(sceneGroup, "images/background/Capa.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")

    -- Definir posições dos objetos
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    btnNext.x = 610
    btnNext.y = 940
    btnVolumeOn.x = display.contentCenterX
    btnVolumeOn.y = 940
    btnVolumeOff.x = display.contentCenterX
    btnVolumeOff.y = 940
    btnVolumeOff.isVisible = false -- O botão de volume desligado começa invisível

    -- Função para tocar o som no canal 1
    local function playSound()
        audio.play(startSound, { loops = -1, channel = 1 })
        btnVolumeOn.isVisible = true
        btnVolumeOff.isVisible = false
        isSoundOn = true
    end

    -- Função para parar o som no canal 1
    local function stopSound()
        audio.stop(1)  -- Parar o som no canal 1
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

    -- Funções de navegação
    function btnNext:tap(event)
        if isSoundOn then stopSound() end
        composer.gotoScene("Page2", { effect = "fromRight", time = 1000 })
    end

    -- Adicionar os ouvintes de eventos
    btnNext:addEventListener("tap", btnNext)
    btnVolumeOn:addEventListener("tap", toggleSound)
    btnVolumeOff:addEventListener("tap", toggleSound)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        -- Tocar o som quando a cena aparecer no canal 1
        -- audio.play(startSound, { loops = -1, channel = 1 })
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    -- if (phase == "will") then
    --     -- Parar o som quando a cena desaparecer no canal 1
    --     -- audio.stop(1)
    --     -- audio.dispose(startSound)
    -- end
end

function scene:destroy(event)
    local sceneGroup = self.view

    -- Parar o som e limpar o canal
    -- audio.stop(1)  -- Parar o som no canal 1
    -- audio.dispose(startSound)  -- Liberar os recursos de áudio
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
