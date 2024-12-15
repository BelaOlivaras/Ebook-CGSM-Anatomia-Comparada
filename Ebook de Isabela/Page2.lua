local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = false

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImage(sceneGroup, "images/background/pagina 2.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local esqueleto = display.newImage(sceneGroup, "images/objects/page2/esqueleto.png")
    local osso1 = display.newImage(sceneGroup, "images/objects/page2/osso1.png")

    -- Definir posições dos objetos
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

    -- Definir visibilidade inicial dos objetos
    btnVolumeOff.isVisible = false
    osso1.isVisible = false
    esqueleto.x = 240
    esqueleto.y = 740
    osso1.x = 240
    osso1.y = 740

    -- Carregar o som de fundo
    local startSound = audio.loadSound("sounds/p2 audio projeto cgsm.MP3")

    -- Função para tocar o som
    local function playSound()
        audio.play(startSound, { loops = -1, channel = 1 })
        btnVolumeOn.isVisible = true
        btnVolumeOff.isVisible = false
        isSoundOn = true
    end

    -- Função para parar o som
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

    -- Adicionar ouvintes para os botões de som
    btnVolumeOn:addEventListener("tap", toggleSound)
    btnVolumeOff:addEventListener("tap", toggleSound)

    -- Funções de navegação entre cenas
    function btnNext:tap(event)
        if isSoundOn then stopSound() end
        composer.gotoScene("Page3", { effect = "fromRight", time = 1000 })
    end

    function btnPrev:tap(event)
        if isSoundOn then stopSound() end
        composer.gotoScene("Capa", { effect = "fromLeft", time = 1000 })
    end

    -- Adicionar ouvintes de eventos de navegação
    btnNext:addEventListener("tap", btnNext)
    btnPrev:addEventListener("tap", btnPrev)

    -- Variáveis para multitouch
    local touches = {}

    local function onTouch(event)
        local id = event.id
        if event.phase == "began" then
            touches[id] = { x = event.x, y = event.y }
        elseif event.phase == "moved" and touches[id] then
            touches[id].x, touches[id].y = event.x, event.y
        elseif event.phase == "ended" or event.phase == "cancelled" then
            touches[id] = nil
        end

        -- Verificar gesto de zoom
        if tableLength(touches) == 2 then
            -- Obter os dois pontos de toque
            local points = {}
            for k, v in pairs(touches) do
                table.insert(points, v)
            end

            -- Calcular a distância entre os pontos
            local dx = points[1].x - points[2].x
            local dy = points[1].y - points[2].y
            local distance = math.sqrt(dx * dx + dy * dy)

            -- Verificar se está fazendo zoom
            if distance > 100 then
                esqueleto.isVisible = false
                osso1.isVisible = true
            end
        end

        return true
    end

    -- Função auxiliar para contar entradas na tabela
    function tableLength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end

    -- Ativar multitouch
    system.activate("multitouch")

    -- Adicionar listener para multitouch
    Runtime:addEventListener("touch", onTouch)
end

function scene:show(event)
    local phase = event.phase

    if phase == "did" then
        -- Parar o som da cena anterior (se houver)
        audio.stop(1)
        
        -- Tocar o som da cena atual
        if startSound then
            audio.play(startSound, { loops = -1, channel = 1 })
        end
    end
end

function scene:hide(event)
    local phase = event.phase

    if phase == "will" then
        -- Parar o som quando a cena desaparecer
        if startSound then
            audio.stop(1)  -- Parar o som no canal 1
        end
    end
end

function scene:destroy(event)
    -- Liberar o som quando a cena for destruída
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
