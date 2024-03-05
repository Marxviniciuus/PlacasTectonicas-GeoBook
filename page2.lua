local composer = require("composer")
local C = require('Constants')

local scene = composer.newScene()
local isAudioPlaying = false
local buttonPlay
local sound
local continentImage
local isShakeDetected = false

local shakeThreshold = 1.5  -- Adjust as necessary

local function onTouch(event)
    if event.phase == "ended" then
        if isAudioPlaying then
            isAudioPlaying = false
            audio.stop()
            audio.dispose(sound)
        else
            isAudioPlaying = true
            sound = audio.loadSound("assets/audio/2audio.mp3")
            audio.play(sound, { onComplete = function() isAudioPlaying = false end })
        end

        buttonPlay:removeEventListener("touch", onTouch)
        timer.performWithDelay(300, function()
            buttonPlay:addEventListener("touch", onTouch)
        end)
    end
end

local function onShake(event)
    if event.isShake and not isShakeDetected then
        isShakeDetected = true
        continentImage:play()
    end
end

local sheetOptions =
{
    width = 166, 
    height = 250,  
    numFrames = 6  
}

local sheetContinent = graphics.newImageSheet("assets/continentes.png", sheetOptions)  -- Replace the path with your spritesheet

local sequencesContinent = {
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

    local backgroundImage = display.newImageRect(sceneGroup, "assets/Página1.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btNext.x, btNext.y, btNext.rotation = display.contentWidth - 60, display.contentHeight - 71, 90
    btNext:addEventListener('tap', function() composer.gotoScene("page3", {effect = "fromRight", time = 1000}) end)

    local btPreview = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btPreview.x, btPreview.y, btPreview.rotation = display.contentWidth - 710, display.contentHeight - 71, 270
    btPreview:addEventListener('tap', function() composer.gotoScene("page1", {effect = "fromLeft", time = 1000}) end)

    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
    buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
    buttonPlay:addEventListener("touch", onTouch)  

    continentImage = display.newSprite(sheetContinent, sequencesContinent)
    continentImage.x, continentImage.y = display.contentCenterX, display.contentCenterY
    sceneGroup:insert(continentImage)  -- Add the sprite to the scene group
    continentImage:addEventListener("sprite", function(event)
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
