local composer = require("composer")

local scene = composer.newScene()

local isSoundOn = true 
local backgroundMusic 

function scene:create(event)
    local sceneGroup = self.view
    local background = display.newImage("images/background/pagina 4.png")
    local btnNext = display.newImage("images/objects/next.png")
    local btnPrev = display.newImage("images/objects/prev.png")
    local btnVolumeOn = display.newImage("images/objects/volume.png")
    local btnVolumeOff = display.newImage("images/objects/volumeoff.png")
    local dna = display.newImage("images/objects/page5/dna.png")
    local circle = display.newImage("images/objects/page5/circle.png")
    local glicose = display.newImage("images/objects/page5/glicose.png")
    local agua = display.newImage("images/objects/page5/agua.png")
    local enzimas = display.newImage("images/objects/page5/enzimas.png")
    local proteina = display.newImage("images/objects/page5/proteinas.png")
    local acidos = display.newImage("images/objects/page5/acidos.png")


    --posicao
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
    circle.x = display.contentCenterX
    circle.y = 650
    dna.x = display.contentCenterX
    dna.y = 800
    glicose.x = display.contentCenterX
    glicose.y = 580
    agua.x = 100
    agua.y = 720
    proteina.x = 220
    proteina.y = 620
    enzimas.x = 550
    enzimas.y = 610
    acidos.x = 640
    acidos.y = 750


    --Visibilidade
    btnVolumeOff.isVisible = false
    acidos.isVisible = false
    enzimas.isVisible = false
    proteina.isVisible = false
    agua.isVisible = false
    glicose.isVisible = false


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
        composer.gotoScene("Page5", { effect = "fromRight", time = 1000 })
    end

    function btnPrev:tap(event)
        composer.gotoScene("Page3", { effect = "fromLeft", time = 1000 })
    end


    local function dragDNA(event)
        if event.phase == "began" then
            display.getCurrentStage():setFocus(dna)
            dna.isFocus = true
        elseif event.phase == "moved" then
            if dna.isFocus then
                dna.x = event.x
                dna.y = event.y

               
                local function checkCollision(obj)
                    local boundsDNA = dna.contentBounds
                    local boundsObj = obj.contentBounds
                    return boundsDNA.xMin < boundsObj.xMax and
                        boundsDNA.xMax > boundsObj.xMin and
                        boundsDNA.yMin < boundsObj.yMax and
                        boundsDNA.yMax > boundsObj.yMin
                end

                if checkCollision(acidos) then acidos.isVisible = true end
                if checkCollision(enzimas) then enzimas.isVisible = true end
                if checkCollision(proteina) then proteina.isVisible = true end
                if checkCollision(agua) then agua.isVisible = true end
                if checkCollision(glicose) then glicose.isVisible = true end
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            if dna.isFocus then
                display.getCurrentStage():setFocus(nil)
                dna.isFocus = false
            end
        end
        return true
    end

    dna:addEventListener("touch", dragDNA)
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
