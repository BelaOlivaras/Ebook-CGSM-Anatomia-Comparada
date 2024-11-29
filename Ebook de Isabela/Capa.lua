local composer = require("composer")

print(display.contentCenterX)
print(display.actualContentHeight)

local scene = composer.newScene()

local isSoundOn = true -- Variable to control the sound state
local backgroundMusic  -- Variable to store the background music

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImage(sceneGroup, "images/background/Capa.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")

    background:translate(display.contentCenterX, display.contentCenterY)
    btnNext:translate(668, 940)
    btnPrev:translate(100, 940)
    btnPrev.isVisible = false
    btnVolumeOn:translate(display.contentCenterX, 940)
    btnVolumeOff:translate(display.contentCenterX, 940)
    btnVolumeOff.isVisible = false

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

    -- Navigation function
    function btnNext:tap(event)
        composer.gotoScene("Page2", { effect = "fromRight", time = 0 })
    end

    function btnPrev:tap(event)
        composer.gotoScene("Capa", { effect = "fromLeft", time = 0 })
    end

    -- Add listeners
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
