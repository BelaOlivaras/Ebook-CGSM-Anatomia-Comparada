local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = false

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImage(sceneGroup, "images/background/pagina 6.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local tree = display.newImage(sceneGroup, "images/objects/page6/tree.png")
    local tree1 = display.newImage(sceneGroup, "images/objects/page6/tree1.png")
    local tree2 = display.newImage(sceneGroup, "images/objects/page6/tree2.png")
    local sun = display.newImage(sceneGroup, "images/objects/page6/sun.png")
    local nuvem = display.newImage(sceneGroup, "images/objects/page6/nuvem.png")

    -- Posicionamento
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    btnNext.x = 610
    btnNext.y = 940
    btnPrev.x = 100
    btnPrev.y = 940
    btnVolumeOn.x = display.contentCenterX
    btnVolumeOn.y = 940
    btnVolumeOff.x = display.contentCenterX
    btnVolumeOff.y = 940
    sun.x = 100
    sun.y = 500
    nuvem.x = 100
    nuvem.y = 500
    tree.x = 510
    tree.y = 700
    tree1.x = 510
    tree1.y = 590
    tree2.x = 510
    tree2.y = 590

    -- Visibilidade
    btnVolumeOff.isVisible = false
    tree2.isVisible = false

    local startSound = audio.loadSound("sounds/p6 audio projeto cgsm(1).MP3")

    local function playSound()
        -- Toca o som no canal 1
        audio.play(startSound, { channel = 1, loops = -1 })
        btnVolumeOn.isVisible = true
        btnVolumeOff.isVisible = false
        isSoundOn = true
    end

    local function stopSound()
        -- Para o som no canal 1
        audio.stop(1)
        btnVolumeOn.isVisible = false
        btnVolumeOff.isVisible = true
        isSoundOn = false
    end

    local function toggleSound()
        if isSoundOn then
            stopSound()
        else
            playSound()
        end
    end

    function btnNext:tap(event)
        if isSoundOn then stopSound() end
        composer.gotoScene("Contracapa", { effect = "fromRight", time = 1000 })
    end

    function btnPrev:tap(event)
        if isSoundOn then stopSound() end
        composer.gotoScene("Page5", { effect = "fromLeft", time = 1000 })
    end

    btnNext:addEventListener("tap", btnNext)
    btnPrev:addEventListener("tap", btnPrev)
    btnVolumeOn:addEventListener("tap", toggleSound)
    btnVolumeOff:addEventListener("tap", toggleSound)

    -- Função para mover a nuvem
    local function checkCloudAndChangeTrees()
        local distanceThreshold = 50 -- Ajuste conforme necessário

        local dx = nuvem.x - sun.x
        local dy = nuvem.y - sun.y
        local distance = math.sqrt(dx * dx + dy * dy) -- Distância Euclidiana

        if distance > distanceThreshold then
            -- Troca as imagens das árvores
            tree1.isVisible = false
            tree2.isVisible = true
        else
            -- Retorna as árvores ao estado original
            tree1.isVisible = true
            tree2.isVisible = false
        end
    end

    -- Função para mover a nuvem
    local function moveCloud(event)
        local phase = event.phase

        if phase == "began" then
            display.currentStage:setFocus(nuvem)
            nuvem.touchOffsetX = event.x - nuvem.x
            nuvem.touchOffsetY = event.y - nuvem.y
        elseif phase == "moved" then
            nuvem.x = event.x - nuvem.touchOffsetX
            nuvem.y = event.y - nuvem.touchOffsetY
            -- Verifica a proximidade da nuvem em relação ao sol
            checkCloudAndChangeTrees()
        elseif phase == "ended" or phase == "cancelled" then
            display.currentStage:setFocus(nil)
            -- Verifica a proximidade da nuvem em relação ao sol
            checkCloudAndChangeTrees()
        end

        return true
    end

    -- Adicionar listener para arrastar a nuvem
    nuvem:addEventListener("touch", moveCloud)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
    elseif (phase == "did") then
        -- Toca o som somente uma vez ao mostrar a cena
        if not audio.isChannelPlaying(1) then
            audio.play(startSound, { channel = 1, loops = -1 })
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Para o som ao esconder a cena
        audio.stop(1)
    elseif (phase == "did") then
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

    if startSound then
        audio.stop(1)             -- Para o som no canal 1
        audio.dispose(startSound) -- Libera o recurso de áudio
        startSound = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
