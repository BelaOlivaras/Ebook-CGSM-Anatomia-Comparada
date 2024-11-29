local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = true -- Variable to control the sound state
local backgroundMusic  -- Variable to store the background music

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImage(sceneGroup, "images/background/pagina 3.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local imagem1 = display.newImage(sceneGroup, "images/objects/page4/imagen1.png")
    local imagem2 = display.newImage(sceneGroup, "images/objects/page4/imagen2.png")
    local imagem3 = display.newImage(sceneGroup, "images/objects/page4/imagen3.png")
    local text = display.newImage(sceneGroup, "images/objects/page4/text.png")

    -- Positioning elements
    background:translate(display.contentCenterX, display.contentCenterY)
    btnNext:translate(668, 940)
    btnPrev:translate(100, 940)
    btnVolumeOn:translate(display.contentCenterX, 940)
    btnVolumeOff:translate(display.contentCenterX, 940)
    imagem1:translate(200, 540)
    imagem2:translate(570, 540)
    imagem3:translate(display.contentCenterX, 720)
    text:translate(display.contentCenterX, 850)

    -- Adjusting sizes
    imagem1.width = 250
    imagem1.height = 150
    imagem2.width = 250
    imagem2.height = 150
    imagem3.width = 250
    imagem3.height = 150

    -- Setting initial visibility
    btnVolumeOff.isVisible = false
    imagem2.isVisible = false
    imagem3.isVisible = false

    -- Loading background sound
    local startSound = audio.loadSound("sounds/audio.mp3")

    local function playSound()
        audio.play(startSound, { loops = -1 })
        btnVolumeOn.isVisible = true
        btnVolumeOff.isVisible = false
    end

    local function stopSound()
        audio.stop()
        btnVolumeOn.isVisible = false
        btnVolumeOff.isVisible = true
    end

    local function toggleSound()
        if isSoundOn then
            stopSound()
            isSoundOn = false
        else
            playSound()
            isSoundOn = true
        end
    end

    -- Event listeners for images
    local function showImagem2()
        imagem2.isVisible = true
    end

    local function showImagem3()
        imagem3.isVisible = true
    end

    function btnNext:tap(event)
        composer.gotoScene("Page5", { effect = "fromRight", time = 0 })
    end

    function btnPrev:tap(event)
        composer.gotoScene("Page3", { effect = "fromLeft", time = 0 })
    end

    btnPrev:addEventListener("tap", btnPrev)
    btnNext:addEventListener("tap", btnNext)
    imagem1:addEventListener("tap", showImagem2)
    imagem2:addEventListener("tap", showImagem3)
    btnVolumeOn:addEventListener("tap", function()
        toggleSound()
    end)
    btnVolumeOff:addEventListener("tap", function()
        toggleSound()
    end)
end

function scene:show(event)
    local phase = event.phase

    if phase == "did" then
        audio.play(startSound, { loops = -1 })
    end
end

function scene:hide(event)
    local phase = event.phase

    if phase == "will" then
        audio.stop()
    end
end

function scene:destroy(event)
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
