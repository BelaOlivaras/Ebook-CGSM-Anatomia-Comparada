local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = true
local backgroundMusic

function scene:create(event)

    local sceneGroup = self.view
    local background = display.newImage("images/background/pagina 5.png")
    local btnNext = display.newImage("images/objects/next.png")
    local btnPrev = display.newImage("images/objects/prev.png")
    local btnVolumeOn = display.newImage("images/objects/volume.png")
    local btnVolumeOff = display.newImage("images/objects/volumeoff.png")
    local tree = display.newImage("images/objects/page6/tree.png")
    local treedeath = display.newImage("images/objects/page6/treedeath.png")
    local sun = display.newImage("images/objects/page6/sun.png")


    --Posicao
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
    sun.y = 800
    treedeath.x = 610
    treedeath.y = 700
    tree.x = 590
    tree.y = 700


    --Visibilidade
    btnVolumeOff.isVisible = false
    tree.isVisible = false

    local startSound = audio.loadSound("sounds/No ComPod, a gente compartilha, (5).mp3")

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

    function btnVolumeOn:tap(event)
        toggleSound()
    end

    function btnVolumeOff:tap(event)
        toggleSound()
    end

    
    function btnNext:tap(event)
        composer.gotoScene("Contracapa", { effect = "fromRight", time = 1000 })
    end

    function btnPrev:tap(event)
        composer.gotoScene("Page4", { effect = "fromLeft", time = 1000 })
    end

    local function moveSun(event)
        -- Update sun position as it's dragged
        sun.x = event.x
        sun.y = event.y

        -- Check if the sun is near the center of the screen
        local centerX, centerY = display.contentCenterX, display.contentCenterY
        local distance = math.sqrt((sun.x - centerX)^2 + (sun.y - centerY)^2)
        if distance < 50 then -- Adjust threshold as needed
            tree.isVisible = true
            treedeath.isVisible = false
        else
            tree.isVisible = false
            treedeath.isVisible = true
        end

        return true
    end

    sun:addEventListener("touch", moveSun)
    btnNext:addEventListener("tap", btnNext)
    btnPrev:addEventListener("tap", btnPrev)
    btnVolumeOn:addEventListener("tap", btnVolumeOn)
    btnVolumeOff:addEventListener("tap", btnVolumeOff)


end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
    elseif (phase == "did") then
        audio.play(startSound, { loops = -1 })
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        audio.stop()
    elseif (phase == "did") then
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
