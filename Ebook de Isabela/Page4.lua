local composer = require("composer")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Local variables
    local isSoundOn = true
    local startSound
    local background = display.newImage(sceneGroup, "images/background/pagina 4.png")
    local btnNext = display.newImage(sceneGroup, "images/objects/next.png")
    local btnPrev = display.newImage(sceneGroup, "images/objects/prev.png")
    local btnVolumeOn = display.newImage(sceneGroup, "images/objects/volume.png")
    local btnVolumeOff = display.newImage(sceneGroup, "images/objects/volumeoff.png")
    local imagem1 = display.newImage(sceneGroup, "images/objects/page4/imagen1.png")
    local imagem2 = display.newImage(sceneGroup, "images/objects/page4/imagen2.png")
    local text = display.newImage(sceneGroup, "images/objects/page4/text.png")

    -- Positioning elements
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
    text.x = display.contentCenterX
    text.y = 850

    -- Adjusting sizes
    imagem1.width = 300
    imagem1.height = 300
    imagem1.x = 70 + (imagem1.width / 2)
    imagem1.y = 470 + (imagem1.height / 2)

    imagem2.width = 300
    imagem2.height = 250
    imagem2.x = 400 + (imagem2.width / 2)
    imagem2.y = 500 + (imagem2.height / 2)

    -- Setting initial visibility
    btnVolumeOff.isVisible = false
    imagem2.isVisible = false

    -- Loading background sound
    startSound = audio.loadSound("sounds/p4 projeto cgsm.MP3")

    -- Function to play sound on channel 1
    local function playSound()
        audio.play(startSound, { channel = 1, loops = -1 })
        btnVolumeOn.isVisible = true
        btnVolumeOff.isVisible = false
        isSoundOn = true
    end

    -- Function to stop sound on channel 1
    local function stopSound()
        audio.stop(1)
        btnVolumeOn.isVisible = false
        btnVolumeOff.isVisible = true
        isSoundOn = false
    end

    -- Function to toggle sound
    local function toggleSound()
        if isSoundOn then
            stopSound()
        else
            playSound()
        end
    end

    -- Event listeners for images
    local function showImagem2()
        imagem2.isVisible = true
    end

    -- Event listeners for navigation
    local function goToNextPage()
        if isSoundOn then stopSound() end
        composer.gotoScene("Page5", { effect = "fromRight", time = 1000 })
    end

    local function goToPreviousPage()
        if isSoundOn then stopSound() end
        composer.gotoScene("Page3", { effect = "fromLeft", time = 1000 })
    end

    -- Add event listeners
    btnPrev:addEventListener("tap", goToPreviousPage)
    btnNext:addEventListener("tap", goToNextPage)
    imagem1:addEventListener("tap", showImagem2)
    btnVolumeOn:addEventListener("tap", toggleSound)
    btnVolumeOff:addEventListener("tap", toggleSound)

    -- Insert elements into the scene group
    sceneGroup:insert(background)
    sceneGroup:insert(btnNext)
    sceneGroup:insert(btnPrev)
    sceneGroup:insert(btnVolumeOn)
    sceneGroup:insert(btnVolumeOff)
    sceneGroup:insert(imagem1)
    sceneGroup:insert(imagem2)
    sceneGroup:insert(text)
end

function scene:show(event)
    local phase = event.phase

    if phase == "did" then
        -- Stop audio from previous scene
        audio.stop(1)
        -- Play the audio for the current scene on channel 1
        audio.play(startSound, { channel = 1, loops = -1 })
    end
end

function scene:hide(event)
    local phase = event.phase

    if phase == "will" then
        -- Stop audio when leaving the scene
        audio.stop(1)
    end
end

function scene:destroy(event)
    -- Stop and clean up the audio when the scene is destroyed
    if startSound then
        audio.stop(1)             -- Ensure the audio stops on channel 1
        audio.dispose(startSound) -- Clean up the audio resource
        startSound = nil          -- Nullify the reference
    end
end

-- Add event listeners for scene phases
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
