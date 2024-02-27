local composer = require("composer")
local C = require('Constants')

local scene = composer.newScene()
local isAudioPlaying = false
local buttonPlay
local sound
local redPoint
local predioImage
local isShakeDetected = false

local shakeThreshold = 1.5  -- Ajuste conforme necessário

local function onTouch(event)
    if event.phase == "ended" then
        if isAudioPlaying then
            isAudioPlaying = false
            audio.stop()
            audio.dispose(sound)
        else
            isAudioPlaying = true
            sound = audio.loadSound("7audio.mp3")
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
        predioImage:play()
    end
end


local function moveRedPoint(event)
    if event.isShake and not isShakeDetected then
        local minY = 178  -- Valor mínimo no eixo Y
        local maxY = display.contentHeight - 200
        local randomY = math.random(minY, maxY)
        transition.to(redPoint, { y = randomY, time = 500, transition = easing.outQuad })
    end
end

local sheetOptions =
{
    width = 166, 
    height = 250,  
    numFrames = 6  
}

local sheetPredio = graphics.newImageSheet("assets/vulcao.png", sheetOptions)  -- Substitua o caminho pela sua spritesheet

local sequencesPredio = {
    {
        name = "move",
        start = 1,
        count = 4,
        time = 0,
        loopCount = 10,  -- Defina para 1 para reprodução única
        loopDirection = "forward"
    }
}

function scene:create(event)
    local sceneGroup = self.view

    local backgroundImage = display.newImageRect(sceneGroup, "assets/Página5.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btNext.x, btNext.y, btNext.rotation = display.contentWidth - 60, display.contentHeight - 78, 90
    btNext:addEventListener('tap', function() composer.gotoScene("page8", {effect = "fromRight", time = 1000}) end)

    local btPreview = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btPreview.x, btPreview.y, btPreview.rotation = display.contentWidth - 710, display.contentHeight - 78, 270
    btPreview:addEventListener('tap', function() composer.gotoScene("page1", {effect = "fromLeft", time = 1000}) end)

    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
    buttonPlay.x, buttonPlay.y = display.contentWidth - 50, 400
    buttonPlay:addEventListener("touch", onTouch)

    redPoint = display.newCircle(sceneGroup, display.contentWidth - 590, 930, 15)
    redPoint:setFillColor(1, 0, 0)
    redPoint:addEventListener("movement",  function(event)
        if event.phase == "ended" then
            isShakeDetected = false
        end
    end)    

    predioImage = display.newSprite( sheetPredio, sequencesPredio )
    predioImage.x, predioImage.y = display.contentCenterX, display.contentCenterY + 100
    sceneGroup:insert(predioImage)  -- Adiciona o sprite ao grupo da cena
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
