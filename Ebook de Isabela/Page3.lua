local composer = require("composer")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    local isSoundOn = true
    local startSound

    -- Variáveis locais dentro da função create
    local background = display.newImage(sceneGroup, "images/background/pagina 3.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local foiljog1 = display.newImage(sceneGroup, "images/objects/page3/jf1.png")
    local foiljog2 = display.newImage(sceneGroup, "images/objects/page3/jf2.png")
    local foil1 = display.newImage(sceneGroup, "images/objects/page3/f1.png")
    local foil2 = display.newImage(sceneGroup, "images/objects/page3/f2.png")

    -- Posições iniciais
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
    foiljog1.x = 600
    foiljog1.y = 200
    foiljog2.x = 150
    foiljog2.y = 200
    foil1.x = 600
    foil1.y = 200
    foil2.x = 150
    foil2.y = 200
    btnVolumeOff.isVisible = false
    foil2.isVisible = false
    foil1.isVisible = false

    -- Carregar som
    startSound = audio.loadSound("sounds/p3 audio projeto cgsm.MP3")

    -- Função para tocar som no canal 1
    local function playSound()
        audio.play(startSound, { channel = 1, loops = -1 })
        btnVolumeOn.isVisible = true
        btnVolumeOff.isVisible = false
    end

    -- Função para parar o som
    local function stopSound()
        audio.stop(1)
        btnVolumeOn.isVisible = false
        btnVolumeOff.isVisible = true
    end

    -- Função para alternar o som
    local function toggleSound()
        if isSoundOn then
            stopSound()
            isSoundOn = false
        else
            playSound()
            isSoundOn = true
        end
    end

    -- Função de navegação para a próxima página
    local function goToNextPage()
        if isSoundOn then stopSound() end
        composer.gotoScene("Page4", { effect = "fromRight", time = 1000 })
    end

    -- Função de navegação para a página anterior
    local function goToPreviousPage()
        if isSoundOn then stopSound() end
        composer.gotoScene("Page2", { effect = "fromLeft", time = 1000 })
    end

    -- Função de animação dos "foils"
    local function animateFoils()
        foil2.isVisible = true
        foil1.isVisible = true
        transition.to(foil1, {
            time = 1000,
            y = 350,
            transition = easing.outBounce
        })
        transition.to(foil2, {
            time = 1200,
            y = 350,
            transition = easing.outBounce
        })
    end

    -- Função de evento para o acelerômetro (shake)
    local function onShake(event)
        if event.isShake then
            animateFoils()
        end
    end

    -- Adicionar listeners para eventos
    btnNext:addEventListener("tap", goToNextPage)
    btnPrev:addEventListener("tap", goToPreviousPage)
    btnVolumeOn:addEventListener("tap", toggleSound)
    btnVolumeOff:addEventListener("tap", toggleSound)
    Runtime:addEventListener("accelerometer", onShake)
end

-- Função que é executada ao mostrar a cena
function scene:show(event)
    local phase = event.phase

    if (phase == "did") then
        audio.play(startSound, { channel = 1, loops = -1 })
    end
end

-- Função que é executada ao esconder a cena
function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        audio.stop(1)
        Runtime:removeEventListener("accelerometer", onShake)
    end
end

-- Função que é executada ao destruir a cena
function scene:destroy(event)
    if startSound then
        audio.dispose(startSound)
        startSound = nil
    end
end

-- Adicionar listeners para as fases da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
