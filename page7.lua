local composer = require("composer")
local C = require('Constants')

local scene = composer.newScene()
local isAudioPlaying = false
local buttonPlay
local sound
local redPoint
local predioImage
local isShakeDetected = false

local shakeThreshold = 1.5

local function onTouch(event)
    if event.phase == "ended" then
        if isAudioPlaying then
            isAudioPlaying = false
            audio.stop()
            audio.dispose(sound)
        else
            isAudioPlaying = true
            sound = audio.loadSound("assets/audio/7audio.mp3")
            audio.play(sound, { onComplete = function() isAudioPlaying = false end })
        end

        buttonPlay:removeEventListener("touch", onTouch)
        timer.performWithDelay(300, function()
            buttonPlay:addEventListener("touch", onTouch)
        end)
    end
end

local function endAudio()
    isAudioPlaying = false
    audio.stop()
end  

local function moveRedPoint()
    local minX = display.contentWidth - 550
    local maxX = display.contentWidth -  165
    local randomX = math.random(minX, maxX)

    if redPoint then
        transition.to(redPoint, { x = randomX, time = 500, transition = easing.outQuad, onComplete = function()
            isShakeDetected = false
        end })
    end
end

local function onShake(event)
    if event.isShake and not isShakeDetected then
        isShakeDetected = true
        predioImage:play()
        moveRedPoint()
    end
end

local sheetOptions =
{
    width = 166, 
    height = 250,  
    numFrames = 6  
}

local sheetPredio = graphics.newImageSheet("assets/predio.png", sheetOptions)

local sequencesPredio = {
    {
        name = "move",
        start = 1,
        count = 6,
        time = 100,
        loopCount = 10,
        loopDirection = "forward"
    }
}

function scene:create(event)
    local sceneGroup = self.view

    local backgroundImage = display.newImageRect(sceneGroup, "assets/Página6.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btNext.x, btNext.y, btNext.rotation = display.contentWidth - 60, display.contentHeight - 78, 90
    btNext:addEventListener("touch", function (event)
        if event.phase == "ended" then
            endAudio()
            composer.removeScene("page7")
            composer.gotoScene("page8", {effect = "fromRight", time = 1000})
        end
    end)

    local btPreview = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btPreview.x, btPreview.y, btPreview.rotation = display.contentWidth - 710, display.contentHeight - 78, 270
    btPreview:addEventListener("touch", function (event)
        if event.phase == "ended" then
            endAudio()
            composer.removeScene("page7")
            composer.gotoScene("page6", {effect = "fromLeft", time = 1000})
        end
    end)

    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
    buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
    buttonPlay:addEventListener("touch", onTouch)

    redPoint = display.newCircle(sceneGroup, display.contentWidth - 580, 840, 15)
    redPoint:setFillColor(1, 0, 0)
    redPoint:addEventListener("sprite", function(event)
        if event.phase == "ended" then
            isShakeDetected = false
        end
    end)    

    predioImage = display.newSprite( sheetPredio, sequencesPredio )
    predioImage.x, predioImage.y = display.contentCenterX, display.contentCenterY + 100
    sceneGroup:insert(predioImage)
    predioImage:addEventListener("sprite", function(event)
        if event.phase == "ended" then
            isShakeDetected = false
        end
    end)
end

function scene:show(event)
    if event.phase == "did" then
        Runtime:addEventListener("accelerometer", onShake)
    end
end

function scene:hide(event)
    if event.phase == "did" then
        Runtime:removeEventListener("accelerometer", onShake)
    end
end

function scene:destroy(event)
    if sound then
        audio.dispose(sound)
        sound = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
