local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = true
local backgroundMusic

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImage(sceneGroup, "images/background/pagina 2.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local foiljog1 = display.newImage(sceneGroup, "images/objects/page3/jf1.png")
    local foiljog2 = display.newImage(sceneGroup, "images/objects/page3/jf2.png")
    local foil1 = display.newImage(sceneGroup, "images/objects/page3/f1.png")
    local foil2 = display.newImage(sceneGroup, "images/objects/page3/f2.png")

    background:translate(display.contentCenterX, display.contentCenterY)
    btnNext:translate(668, 940)
    btnPrev:translate(100, 940)
    btnVolumeOn:translate(display.contentCenterX, 940)
    btnVolumeOff:translate(display.contentCenterX, 940)
    foiljog1:translate(600, 200)
    foiljog2:translate(150, 200)

    -- Foils start off-screen at the top
    foil1:translate(600, 200)
    foil1.isVisible = false
    foil2:translate(150, 200)
    foil2.isVisible = false

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
        composer.gotoScene("Page4", { effect = "fromRight", time = 0 })
    end

    function btnPrev:tap(event)
        composer.gotoScene("Page2", { effect = "fromLeft", time = 0 })
    end

    -- Function to animate foils falling into place
    local function onShake(event)
        if event.isShake then
            -- Animate foil1
            foil1.isVisible = true
            transition.to(foil1, {
                time = 1000,
                y = 350, -- Final position
                transition = easing.outBounce,
            })
            -- Animate foil2
            foil2.isVisible = true
            transition.to(foil2, {
                time = 1200,
                y = 350, -- Final position
                transition = easing.outBounce,
            })
        end

        return true
    end

    -- Add listeners for shake and buttons
    Runtime:addEventListener("accelerometer", onShake)
    btnNext:addEventListener("tap", btnNext)
    btnPrev:addEventListener("tap", btnPrev)
    btnVolumeOn:addEventListener("tap", btnVolumeOn)
    btnVolumeOff:addEventListener("tap", btnVolumeOff)

    -- Add elements to the scene group
    -- sceneGroup:insert(background)
    -- sceneGroup:insert(btnNext)
    -- sceneGroup:insert(btnPrev)
    -- sceneGroup:insert(btnVolumeOn)
    -- sceneGroup:insert(btnVolumeOff)
    -- sceneGroup:insert(foil1)
    -- sceneGroup:insert(foil2)
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
        Runtime:removeEventListener("accelerometer", onShake)
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
