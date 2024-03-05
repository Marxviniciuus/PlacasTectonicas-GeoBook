local composer = require("composer")
local C = require('Constants')

local scene = composer.newScene()
local isAudioPlaying = false
local buttonPlay
local sound
local vulcanImage
local touchArea -- Novo: retângulo invisível para detectar o toque
local isRubbing = false -- Nova: variável para indicar esfregamento
local touchStartTime = 0  -- Variável para registrar o tempo inicial do toque
local rubCount = 0

local function onTouch(event)
    if event.phase == "ended" then
        if isAudioPlaying then
            isAudioPlaying = false
            audio.stop()
            audio.dispose(sound)
        else
            isAudioPlaying = true
            sound = audio.loadSound("assets/audio/6audio.mp3")
            audio.play(sound, { onComplete = function() isAudioPlaying = false end })
        end

        buttonPlay:removeEventListener("touch", onTouch)
        timer.performWithDelay(300, function()
            buttonPlay:addEventListener("touch", onTouch)
        end)
    end
end

local function onVulcanTouch(event)
    if event.phase == "began" then
        -- Se o dedo começou a tocar na área do vulcão
        touchArea.isFocused = true
        touchStartTime = system.getTimer()  -- Registra o tempo inicial do toque
        isRubbing = false
    elseif (event.phase == "ended" or event.phase == "cancelled") and touchArea.isFocused then
        -- Se o dedo saiu da área do vulcão
        touchArea.isFocused = false
        isRubbing = false  -- Reseta a variável ao finalizar o toque

        -- Verifica se o toque persistiu por mais de 0.5 segundos
        local touchDuration = system.getTimer() - touchStartTime
        if touchDuration > 2000 then
            vulcanImage:setSequence("move")
            vulcanImage:play()
        end
    end

    return true  -- Indica que o evento foi manipulado
end

local sheetOptions =
{
    width = 250, 
    height = 250,  
    numFrames = 4  
}

local sheetVulcan = graphics.newImageSheet("assets/vulcao.png", sheetOptions)

local sequencesVulcan = {
    {
        name = "move",
        start = 1,
        count = 4,
        time = 100,
        loopCount = 10,
        loopDirection = "forward"
    }
}

function scene:create(event)
    local sceneGroup = self.view

    local backgroundImage = display.newImageRect(sceneGroup, "assets/Página5.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 60)
    btNext.x, btNext.y, btNext.rotation = display.contentWidth - 60, display.contentHeight - 78, 90
    btNext:addEventListener('tap', function() composer.gotoScene("page7", {effect = "fromRight", time = 1000}) end)

    local btPreview = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btPreview.x, btPreview.y, btPreview.rotation = display.contentWidth - 710, display.contentHeight - 78, 270
    btPreview:addEventListener('tap', function() composer.gotoScene("page5", {effect = "fromLeft", time = 1000}) end)

    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
    buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
    buttonPlay:addEventListener("touch", onTouch)  

    vulcanImage = display.newSprite(sheetVulcan, sequencesVulcan)
    vulcanImage.x, vulcanImage.y = display.contentCenterX, display.contentCenterY + 100
    sceneGroup:insert(vulcanImage)

    -- Retângulo semi invisível para detectar o toque
    touchArea = display.newRect(sceneGroup, 380, 620, 200, 200)
    touchArea:setFillColor(1, 0, 0, 0,01)  -- Vermelho semi invisível
    touchArea.isHitTestable = true
    touchArea:addEventListener("touch", onVulcanTouch)
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
