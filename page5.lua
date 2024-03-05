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
        imagemAtivada1.isVisible = false
        imagemArrastavel1.isVisible = true
        imagemArrastavel1.x, imagemArrastavel1.y = imagemArrastavel1.markX, imagemArrastavel1.markY
    elseif imagemAtivada2.isVisible then
        imagemAtivada2.isVisible = false
        imagemArrastavel2.isVisible = true
        imagemArrastavel2.x, imagemArrastavel2.y = imagemArrastavel2.markX, imagemArrastavel2.markY
    elseif imagemAtivada3.isVisible then
        imagemAtivada3.isVisible = false
        imagemArrastavel3.isVisible = true
        imagemArrastavel3.x, imagemArrastavel3.y = imagemArrastavel3.markX, imagemArrastavel3.markY
    end
end

local function centralizeActivatedImages()
    local x, y = redRectangle:localToContent(0, 0)  -- Coordenadas globais do canto superior esquerdo do retângulo
    local centerX = x + redRectangle.width / 2
    local centerY = y + redRectangle.height / 2

    imagemAtivada1.x, imagemAtivada1.y = centerX, centerY
    imagemAtivada2.x, imagemAtivada2.y = centerX, centerY
    imagemAtivada3.x, imagemAtivada3.y = centerX, centerY
end

local function drag(event)
    local imageDragged = event.target

    if event.phase == "began" then
        hideCurrentImage()  -- Esconde a imagem atual ao começar a arrastar outra
        imageDragged.markX = imageDragged.x
        imageDragged.markY = imageDragged.y
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart) + imageDragged.markX
        local y = (event.y - event.yStart) + imageDragged.markY
        imageDragged.x, imageDragged.y = x, y
    elseif event.phase == "ended" or event.phase == "cancelled" then
        local x, y = redRectangle:localToContent(0, 0) -- Obtem as coordenadas globais do canto superior esquerdo do retângulo

        if imageDragged.x > x and imageDragged.x < x + redRectangle.width
        and imageDragged.y > y and imageDragged.y < y + redRectangle.height then
            -- A imagem arrastável está dentro do retângulo vermelho
            centralizeActivatedImages()  -- Centraliza as imagens ativadas
            if imageDragged == imagemArrastavel1 then
                imagemAtivada1.isVisible = true
                imagemAtivada1.alpha = 1
                imagemArrastavel1.isVisible = false
            elseif imageDragged == imagemArrastavel2 then
                imagemAtivada2.isVisible = true
                imagemAtivada2.alpha = 1
                imagemArrastavel2.isVisible = false
            elseif imageDragged == imagemArrastavel3 then
                imagemAtivada3.isVisible = true
                imagemAtivada3.alpha = 1
                imagemArrastavel3.isVisible = false
            end
        else
            imageDragged.x, imageDragged.y = imageDragged.markX, imageDragged.markY
        end
    end

    return true
end

function scene:create(event)
    local sceneGroup = self.view

    local backgroundImage = display.newImageRect(sceneGroup, "assets/Página4.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btNext.x, btNext.y, btNext.rotation = display.contentWidth - 60, display.contentHeight - 78, 90
    btNext:addEventListener('tap', function() composer.gotoScene("page6", {effect = "fromRight", time = 1000}) end)

    local btPreview = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btPreview.x, btPreview.y, btPreview.rotation = display.contentWidth - 710, display.contentHeight - 80, 270
    btPreview:addEventListener('tap', function() composer.gotoScene("page4", {effect = "fromLeft", time = 1000}) end)

    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
    buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
    buttonPlay:addEventListener("touch", onTouch)

    redRectangle = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, 250, 250)
    redRectangle:setFillColor(1, 0, 0)
    redRectangle.alpha = 1

    imagemArrastavel1 = display.newImageRect(sceneGroup, "assets/nome1.png", 228, 53)
    imagemArrastavel1.x, imagemArrastavel1.y = display.contentWidth * 0.2, display.contentHeight * 0.7
    imagemArrastavel1.isVisible = true

    imagemArrastavel2 = display.newImageRect(sceneGroup, "assets/nome2.png", 230, 53)
    imagemArrastavel2.x, imagemArrastavel2.y = display.contentWidth * 0.5, display.contentHeight * 0.7
    imagemArrastavel2.isVisible = true

    imagemArrastavel3 = display.newImageRect(sceneGroup, "assets/nome3.png", 202, 48)
    imagemArrastavel3.x, imagemArrastavel3.y = display.contentWidth * 0.8, display.contentHeight * 0.7
    imagemArrastavel3.isVisible = true

    imagemAtivada1 = display.newImageRect(sceneGroup, "assets/colisao.png", 250, 250)
    imagemAtivada1.x, imagemAtivada1.y = display.contentWidth * 0.5, display.contentHeight * 0.5
    imagemAtivada1.isVisible = false

    imagemAtivada2 = display.newImageRect(sceneGroup, "assets/afastamento.png", 250, 250)
    imagemAtivada2.x, imagemAtivada2.y = display.contentWidth * 0.5, display.contentHeight * 0.5
    imagemAtivada2.isVisible = false

    imagemAtivada3 = display.newImageRect(sceneGroup, "assets/lateral.png", 250, 250)
    imagemAtivada3.x, imagemAtivada3.y = display.contentWidth * 0.5, display.contentHeight * 0.5
    imagemAtivada3.isVisible = false

    -- Adiciona evento de toque para as imagens
    imagemArrastavel1:addEventListener("touch", drag)
    imagemArrastavel2:addEventListener("touch", drag)
    imagemArrastavel3:addEventListener("touch", drag)

end

function scene:show(event)
    -- ...
end

function scene:hide(event)
    -- ...
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
