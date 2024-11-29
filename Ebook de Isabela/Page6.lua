local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = true
local backgroundMusic

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImage(sceneGroup, "images/background/pagina 5.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local tree = display.newImage(sceneGroup, "images/objects/page6/tree.png")
    local treedeath = display.newImage(sceneGroup, "images/objects/page6/treedeath.png")
    local sun = display.newImage(sceneGroup, "images/objects/page6/sun.png")

    --Posicao
    background:translate(display.contentCenterX, display.contentCenterY)
    btnNext:translate(668, 940)
    btnPrev:translate(100, 940)
    btnVolumeOn:translate(display.contentCenterX, 940)
    btnVolumeOff:translate(display.contentCenterX, 940)
    sun:translate(100, 800)
    treedeath:translate(610, 700)
    tree:translate(590, 700)

    --Visibilidade
    btnVolumeOff.isVisible = false
    tree.isVisible = false

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

    function btnVolumeOn:tap(event)
        toggleSound()
    end

    function btnVolumeOff:tap(event)
        toggleSound()
    end

    function btnNext:tap(event)
        composer.gotoScene("Contracapa", { effect = "fromRight", time = 0 })
    end

    function btnPrev:tap(event)
        composer.gotoScene("Page5", { effect = "fromLeft", time = 0 })
    end

    local function moveSun(event)
        -- Update sun position as it's dragged
        sun.x = event.x
        sun.y = event.y

        -- Check if the sun is near the center of the screen
        local center = { x = display.contentCenterX + 20, y = display.contentCenterY + 20 }
        local distance = math.sqrt((sun.x - center.x) ^ 2 + (sun.y - center.y) ^ 2)
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

    if phase == "will" then
    elseif phase == "did" then
        audio.play(startSound, { loops = -1 })
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        audio.stop()
    elseif phase == "did" then
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
