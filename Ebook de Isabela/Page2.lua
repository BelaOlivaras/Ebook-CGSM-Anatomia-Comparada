local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = true -- Variable to control the sound state
local backgroundMusic  -- Variable to store the background music

local debugText

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImage(sceneGroup, "images/background/pagina 1.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local armOpitons = { width = 184, height = 216, numFrames = 1, sheetContentWidth = 184, sheetContentHeight = 216 }
    local armImg = display.newImage(sceneGroup, graphics.newImageSheet("images/objects/page2/braco.jpg", armOpitons))
    local batOpitons = { width = 265, height = 214, numFrames = 1, sheetContentWidth = 265, sheetContentHeight = 214 }
    local batImg = display.newImage(sceneGroup, graphics.newImageSheet("images/objects/page2/morcego.jpg", batOpitons))

    background:translate(display.contentCenterX, display.contentCenterY)
    btnNext:translate(668, 940)
    btnPrev:translate(100, 940)
    btnVolumeOn:translate(display.contentCenterX, 940)
    btnVolumeOff:translate(display.contentCenterX, 940)
    btnVolumeOff.isVisible = false
    armImg:translate(display.contentCenterX - armOpitons.width, 750)
    batImg:translate(display.contentCenterX + batOpitons.width / 2, 750)

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
        composer.gotoScene("Page3", { effect = "fromRight", time = 0 })
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

    print(phase)

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

    debugText:removeSelf()
    debugText = nil

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
