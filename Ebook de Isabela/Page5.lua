local composer = require("composer")
local scene = composer.newScene()

-- Ativar física
local physics = require("physics")
physics.start()

local isSoundOn = false

function scene:create(event)
    local sceneGroup = self.view

    -- Carregar sons
    local startSound = audio.loadSound("sounds/p5 projeto cgsm.MP3")

    -- Elementos visuais
    local background = display.newImage(sceneGroup, "images/background/pagina 5.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local carne = display.newImage(sceneGroup, "images/objects/page5/carne.png")
    local chave = display.newImage(sceneGroup, "images/objects/page5/chave.png")
    local escudo = display.newImage(sceneGroup, "images/objects/page5/escudo.png")
    local manteiga = display.newImage(sceneGroup, "images/objects/page5/manteiga.png")
    local pao = display.newImage(sceneGroup, "images/objects/page5/pao.png")
    local torneira = display.newImage(sceneGroup, "images/objects/page5/torneira.png")
    local raio = display.newImage(sceneGroup, "images/objects/page5/raio.png")

    -- Linhas e posições
    local linha = display.newLine(sceneGroup, 0, 100, 0, 0)
    linha:setStrokeColor(0, 0, 1)
    linha.strokeWidth = 3
    local linha2 = display.newLine(sceneGroup, 210, 0, 0, 0)
    linha2:setStrokeColor(0, 0, 1)
    linha2.strokeWidth = 3
    local linha3 = display.newLine(sceneGroup, 0, 45, 0, 0)
    linha3:setStrokeColor(0, 0, 1)
    linha3.strokeWidth = 3
    local linha4 = display.newLine(sceneGroup, 200, 0, 0, 0)
    linha4:setStrokeColor(0, 0, 1)
    linha4.strokeWidth = 3
    local linha5 = display.newLine(sceneGroup, 0, 40, 0, 0)
    linha5:setStrokeColor(0, 0, 1)
    linha5.strokeWidth = 3
    local linha6 = display.newLine(sceneGroup, 100, 0, 0, 0)
    linha6:setStrokeColor(0, 0, 1)
    linha6.strokeWidth = 3
    local linha7 = display.newLine(sceneGroup, 0, 100, 0, 0)
    linha7:setStrokeColor(0, 0, 1)
    linha7.strokeWidth = 3

    -- Configuração de posições e visibilidade
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
    torneira.x = 610
    torneira.y = 550
    pao.x = 450
    pao.y = 680
    raio.x = 450
    raio.y = 680
    carne.x = 300
    carne.y = 720
    chave.x = 300
    chave.y = 720
    manteiga.x = 150
    manteiga.y = 750
    escudo.x = 150
    escudo.y = 750

    linha.x = 610
    linha.y = 700
    linha2.x = 610
    linha2.y = 700
    linha3.x = 400
    linha3.y = 750
    linha4.x = 400
    linha4.y = 750
    linha5.x = 200
    linha5.y = 790
    linha6.x = 200
    linha6.y = 790
    linha7.x = 100
    linha7.y = 790

    btnVolumeOff.isVisible = false
    raio.isVisible = false
    chave.isVisible = false
    escudo.isVisible = false

    -- Configurações de física
    linha.isSensor = true
    linha2.isSensor = true
    linha3.isSensor = true
    linha4.isSensor = true
    linha5.isSensor = true
    linha6.isSensor = true
    linha7.isSensor = true

    physics.addBody(linha, "static", { density = 1, friction = 0, bounce = 0 })
    physics.addBody(linha2, "static", { density = 1, friction = 0, bounce = 0 })
    physics.addBody(linha3, "static", { density = 1, friction = 0, bounce = 0 })
    physics.addBody(linha4, "static", { density = 1, friction = 0, bounce = 0 })
    physics.addBody(linha5, "static", { density = 1, friction = 0, bounce = 0 })
    physics.addBody(linha6, "static", { density = 1, friction = 0, bounce = 0 })
    physics.addBody(linha7, "static", { density = 1, friction = 0, bounce = 0 })

    manteiga.myName = "manteiga"
    physics.addBody(manteiga, "static", { density = 1, friction = 0, bounce = 0 })
    carne.myName = "carne"
    physics.addBody(carne, "static", { density = 1, friction = 0, bounce = 0 })
    pao.myName = "pao"
    physics.addBody(pao, "static", { density = 1, friction = 0, bounce = 0 })

    -- Função para criar instâncias de água
    local aguaInstances = {}
    local function createWater()
        if #aguaInstances >= 150 then return end
        for i = 1, 10 do
            local agua = display.newImage(sceneGroup, "images/objects/page5/Ellipse 8.png")
            agua.x = 560
            agua.y = 610
            physics.addBody(agua, { density = 1, friction = 0.5, bounce = 0.3 })
            table.insert(aguaInstances, agua)
        end
    end

    -- Função de som
    local function playSound()
        audio.play(startSound, { loops = -1, channel = 1 })
        btnVolumeOn.isVisible = true
        btnVolumeOff.isVisible = false
        isSoundOn = true
    end

    local function stopSound()
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

    -- Eventos de som
    btnVolumeOn:addEventListener("tap", toggleSound)
    btnVolumeOff:addEventListener("tap", toggleSound)

    -- Eventos de navegação
    btnNext:addEventListener("tap", function()
        if isSoundOn then stopSound() end
        composer.gotoScene("Page6", { effect = "fromRight", time = 1000 })
    end)

    btnPrev:addEventListener("tap", function()
        if isSoundOn then stopSound() end
        composer.gotoScene("Page4", { effect = "fromLeft", time = 1000 })
    end)

    -- Função de colisão
    local function onCollision(self, event)
        if event.phase == "began" then
            print(self.myName)
            if self.myName == "pao" then
                raio.isVisible = true
            elseif self.myName == "carne" then
                chave.isVisible = true
            elseif self.myName == "manteiga" then
                escudo.isVisible = true
            end
            self:removeSelf()
        end
    end

    for _, item in ipairs({ manteiga, carne, pao }) do
        item.collision = onCollision
        item:addEventListener("collision")
    end

    -- manteiga:addEventListener("collision", onCollision)
    -- carne:addEventListener("collision", onCollision)
    -- pao:addEventListener("collision", onCollision)

    -- Adicionar listener de colisão à água
    for _, agua in ipairs(aguaInstances) do
        agua:addEventListener("collision", onCollision)
    end

    -- Evento de toque na torneira para ligar a água
    torneira:addEventListener("tap", function()
        createWater() -- Chama a função para criar a água quando a torneira é tocada
    end)
end

function scene:show(event)
    local phase = event.phase

    if (phase == "did") then
        audio.play(startSound, { loops = -1, channel = 1 })
    end
end

function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        audio.stop(1)
    end
end

function scene:destroy(event)
    if startSound then
        audio.stop(1)             -- Ensure the audio stops on channel 1
        audio.dispose(startSound) -- Clean up the audio resource
        startSound = nil
    end
    physics.pause()
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
