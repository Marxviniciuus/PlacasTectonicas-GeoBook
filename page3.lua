local composer = require("composer")
local C = require('Constants')
local widget = require("widget")
local scene = composer.newScene()
local isAudioPlaying = false
local buttonPlay
local sound
local arrow
local eruptionImage
local lastTouchTime = 0



local function onTouch(event)
    if event.phase == "ended" then
        if isAudioPlaying then
            isAudioPlaying = false
            audio.stop()
            audio.dispose(sound)
        else
            isAudioPlaying = true
            sound = audio.loadSound("assets/audio/3audio.mp3")
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

local sheetOptions =
{
    width = 250, 
    height = 250,  
    numFrames = 4  
}

local sheetEruption = graphics.newImageSheet("assets/eruption.png", sheetOptions)  -- Substitua o caminho pela sua spritesheet

local sequencesEruption = {
    {
        name = "move",
        start = 1,
        count = 4,
        time = 100,
        loopCount = 10,
        loopDirection = "forward"
    }
}

local function onArrowTouch(event)
    local phase = event.phase

    if phase == "began" then
        lastTouchTime = system.getTimer()  -- Armazena o tempo do início do toque
    elseif phase == "moved" then
        local angle = math.atan2(event.y - arrow.y, event.x - arrow.x)
        local rotation = math.deg(angle)
        arrow.rotation = rotation

        -- Calcula a velocidade do movimento usando o tempo do sistema
        local currentTime = system.getTimer()
        local deltaTime = currentTime - lastTouchTime
        lastTouchTime = currentTime  -- Atualiza o tempo do último toque

        local speed = math.sqrt((event.x - event.xStart)^2 + (event.y - event.yStart)^2) / deltaTime
        local thresholdSpeed = 10  -- ajuste conforme necessário

        if speed > thresholdSpeed then
            eruptionImage:play()
            print("Velocidade atingida!")
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view

    local backgroundImage = display.newImageRect(sceneGroup, "assets/Página2.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btNext.x, btNext.y, btNext.rotation = display.contentWidth - 58, display.contentHeight - 79, 90
    btNext:addEventListener("touch", function (event)
        if event.phase == "ended" then
            endAudio()
            composer.removeScene("page3")
            composer.gotoScene("page4", {effect = "fromRight", time = 1000})
        end
    end)

    local btPreview = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btPreview.x, btPreview.y, btPreview.rotation = display.contentWidth - 700, display.contentHeight - 78, 270
    btPreview:addEventListener("touch", function (event)
        if event.phase == "ended" then
            endAudio()
            composer.removeScene("page3")
            composer.gotoScene("page2", {effect = "fromLeft", time = 1000})
        end
    end)

    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
    buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
    buttonPlay:addEventListener("touch", onTouch)

    arrow = display.newImageRect(sceneGroup, "assets/setaCircular.png", 64, 64)
    arrow.x, arrow.y, arrow.rotation = display.contentCenterX, display.contentCenterY + 220, 0
    arrow:addEventListener("touch", onArrowTouch)

    eruptionImage = display.newSprite( sheetEruption, sequencesEruption )
    eruptionImage.x, eruptionImage.y = display.contentCenterX, display.contentCenterY + 50
    sceneGroup:insert(eruptionImage) 

end

function scene:show(event)
  
end

function scene:hide(event)
   
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
