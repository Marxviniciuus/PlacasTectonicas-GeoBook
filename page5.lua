local composer = require("composer")

local scene = composer.newScene()

local isAudioPlaying = false
local buttonPlay
local sound
local imagemArrastavel1, imagemArrastavel2, imagemArrastavel3  -- Imagens que podem ser arrastadas
local imagemAtivada1, imagemAtivada2, imagemAtivada3        -- Imagens ativadas ao dar match

local redRectangle

local function onTouch(event)
    if event.phase == "ended" then
        if isAudioPlaying then
            isAudioPlaying = false
            audio.stop()
            audio.dispose(sound)
        else
            isAudioPlaying = true
            sound = audio.loadSound("assets/audio/5audio.mp3")
            audio.play(sound, { onComplete = function() isAudioPlaying = false end })
        end

        buttonPlay:removeEventListener("touch", onTouch)
        timer.performWithDelay(300, function()
            buttonPlay:addEventListener("touch", onTouch)
        end)
    end
end

local function hideCurrentImage()
    if imagemAtivada1.isVisible then
        display.remove(imagemArrastavel1)
        imagemArrastavel1 = nil
        imagemAtivada1.isVisible = false
    elseif imagemAtivada2.isVisible then
        display.remove(imagemArrastavel2)
        imagemArrastavel2 = nil
        imagemAtivada2.isVisible = false
    elseif imagemAtivada3.isVisible then
        display.remove(imagemArrastavel3)
        imagemArrastavel3 = nil
        imagemAtivada3.isVisible = false
    end
end

local function centralizeActivatedImages()
    local x, y = redRectangle:localToContent(0, 0)
    local centerX = x + redRectangle.width / 2
    local centerY = y + redRectangle.height / 2

    if imagemAtivada1.isVisible then
        imagemAtivada1.x, imagemAtivada1.y = centerX, centerY
    end

    if imagemAtivada2.isVisible then
        imagemAtivada2.x, imagemAtivada2.y = centerX, centerY
    end

    if imagemAtivada3.isVisible then
        imagemAtivada3.x, imagemAtivada3.y = centerX, centerY
    end
end

local function resetDraggedImage(imageDragged)
    if imageDragged then
        imageDragged.x, imageDragged.y = imageDragged.origX, imageDragged.origY
    end
end

local function revealImage(image)
    transition.to(image, { alpha = 1, time = 500 })
end

local function checkCollision(obj1, obj2)
    local bounds1 = obj1.contentBounds
    local bounds2 = obj2.contentBounds

    return (bounds1.xMin < bounds2.xMax and bounds1.xMax > bounds2.xMin) and
           (bounds1.yMin < bounds2.yMax and bounds1.yMax > bounds2.yMin)
end

local function drag(event)
    local imageDragged = event.target

    if event.phase == "began" then
        hideCurrentImage()
        imageDragged.markX = imageDragged.x
        imageDragged.markY = imageDragged.y
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart) + imageDragged.markX
        local y = (event.y - event.yStart) + imageDragged.markY
        imageDragged.x, imageDragged.y = x, y
    elseif event.phase == "ended" or event.phase == "cancelled" then
        local x, y = redRectangle:localToContent(0, 0)

        if x and y and checkCollision(imageDragged, redRectangle) then
            centralizeActivatedImages()
            revealImage(imageDragged)

            if imageDragged == imagemArrastavel1 then
                imagemAtivada1.isVisible = true
                imagemAtivada1.alpha = 0.01
                imagemAtivada1.alpha = 1
                display.remove(imagemArrastavel1)
                imagemArrastavel1 = nil
            elseif imageDragged == imagemArrastavel2 then
                imagemAtivada2.isVisible = true
                imagemAtivada2.alpha = 0.01
                imagemAtivada2.alpha = 1
                display.remove(imagemArrastavel2)
                imagemArrastavel2 = nil
            elseif imageDragged == imagemArrastavel3 then
                imagemAtivada3.isVisible = true
                imagemAtivada3.alpha = 0.01
                imagemAtivada3.alpha = 1
                display.remove(imagemArrastavel3)
                imagemArrastavel3 = nil
            end
        else
            resetDraggedImage(imageDragged)
        end
    end

    return true
end

function scene:create(event)
    local sceneGroup = self.view

    local backgroundImage = display.newImageRect(sceneGroup, "assets/Página4.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    redRectangle = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, 250, 250)
    redRectangle:setFillColor(1, 0, 0)
    redRectangle.alpha = 0.01

    imagemArrastavel1 = display.newImageRect(sceneGroup, "assets/nome1.png", 228, 53)
    imagemArrastavel1.x, imagemArrastavel1.y = display.contentWidth * 0.2, display.contentHeight * 0.7
    imagemArrastavel1.origX, imagemArrastavel1.origY = imagemArrastavel1.x, imagemArrastavel1.y
    imagemArrastavel1.isVisible = true
    
    imagemArrastavel2 = display.newImageRect(sceneGroup, "assets/nome2.png", 230, 53)
    imagemArrastavel2.x, imagemArrastavel2.y = display.contentWidth * 0.5, display.contentHeight * 0.7
    imagemArrastavel2.origX, imagemArrastavel2.origY = imagemArrastavel2.x, imagemArrastavel2.y
    imagemArrastavel2.isVisible = true
    
    imagemArrastavel3 = display.newImageRect(sceneGroup, "assets/nome3.png", 202, 48)
    imagemArrastavel3.x, imagemArrastavel3.y = display.contentWidth * 0.8, display.contentHeight * 0.7
    imagemArrastavel3.origX, imagemArrastavel3.origY = imagemArrastavel3.x, imagemArrastavel3.y
    imagemArrastavel3.isVisible = true

    imagemAtivada1 = display.newImageRect(sceneGroup, "assets/colisao.png", 250, 250)
    imagemAtivada1.x, imagemAtivada1.y = display.contentCenterX, display.contentCenterY
    imagemAtivada1.isVisible = false

    imagemAtivada2 = display.newImageRect(sceneGroup, "assets/afastamento.png", 250, 250)
    imagemAtivada2.x, imagemAtivada2.y = display.contentCenterX, display.contentCenterY
    imagemAtivada2.isVisible = false

    imagemAtivada3 = display.newImageRect(sceneGroup, "assets/lateral.png", 250, 250)
    imagemAtivada3.x, imagemAtivada3.y = display.contentCenterX, display.contentCenterY
    imagemAtivada3.isVisible = false

    imagemArrastavel1:addEventListener("touch", drag)
    imagemArrastavel2:addEventListener("touch", drag)
    imagemArrastavel3:addEventListener("touch", drag)

    local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btNext.x, btNext.y, btNext.rotation = display.contentWidth - 60, display.contentHeight - 78, 90
    btNext:addEventListener('tap', function() composer.gotoScene("page6", {effect = "fromRight", time = 1000}) end)

    local btPreview = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btPreview.x, btPreview.y, btPreview.rotation = display.contentWidth - 710, display.contentHeight - 80, 270
    btPreview:addEventListener('tap', function() composer.gotoScene("page4", {effect = "fromLeft", time = 1000}) end)

    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
    buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
    buttonPlay:addEventListener("touch", onTouch)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if event.phase == "will" then
        resetDraggedImage(imagemArrastavel1)
        resetDraggedImage(imagemArrastavel2)
        resetDraggedImage(imagemArrastavel3)
    elseif phase == "did" then
        
    end
end

function scene:hide(event)
    if event.phase == "will" then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif event.phase == "did" then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end

function scene:destroy(event)
    local sceneGroup = self.view


    if sound then
        audio.dispose(sound)
        sound = nil
    end

    -- Remove event listeners
    imagemArrastavel1:removeEventListener("touch", drag)
    imagemArrastavel2:removeEventListener("touch", drag)
    imagemArrastavel3:removeEventListener("touch", drag)

    -- Remove display objects
    display.remove(imagemArrastavel1)
    display.remove(imagemArrastavel2)
    display.remove(imagemArrastavel3)
    display.remove(imagemAtivada1)
    display.remove(imagemAtivada2)
    display.remove(imagemAtivada3)
    display.remove(redRectangle)
    display.remove(buttonPlay)

    -- Set variables to nil
    imagemArrastavel1, imagemArrastavel2, imagemArrastavel3 = nil, nil, nil
    imagemAtivada1, imagemAtivada2, imagemAtivada3 = nil, nil, nil
    redRectangle, buttonPlay = nil, nil

    composer.removeScene("scene")
    sceneGroup = nil
end

-- Create scene is called every time the scene is created or re-created
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
