local composer = require("composer")

local scene = composer.newScene()
local isAudioPlaying = false
local buttonPlay
local sound
local shakeThreshold = 1.5  -- Ajuste conforme necessário
local redPoint
local predioImage  -- Nova imagem para shakePNG

-- Função para manipular o toque no botão de áudio
local function onTouch(event)
    if event.phase == "ended" then
        if isAudioPlaying then
            isAudioPlaying = false
            buttonPlay:removeSelf()
            buttonPlay = display.newImageRect(scene.view, "assets/audio.png", 140, 140)
            audio.stop()
            audio.dispose(sound)
        else
            isAudioPlaying = true
            buttonPlay:removeSelf()
            buttonPlay = display.newImageRect(scene.view, "assets/audio.png", 301, 167)
            sound = audio.loadSound("7audio.mp3")
            audio.play(sound, { onComplete = function() isAudioPlaying = false end })
        end
        buttonPlay.x = display.contentWidth - 150
        buttonPlay.y = 200
        buttonPlay:addEventListener("touch", onTouch)
    end
end

-- Função para atualizar a posição do ponto vermelho com base na velocidade
local function updateRedPoint(velocity)
    local pointValue = math.min(math.abs(velocity) * 2, 10)  -- Ajuste conforme necessário
    redPoint.text = tostring(math.ceil(pointValue))
end

-- Função para atualizar a posição do PNG chacoalhante
local function shakePNG()
    transition.to(predioImage, {time = 100, x = predioImage.x + math.random(-5, 5), y = predioImage.y + math.random(-5, 5), onComplete = shakePNG})
end

-- Função para criar a cena
function scene:create(event)
    local sceneGroup = self.view

    -- Background (mesmo código)

    -- Setas (mesmo código)

    -- Adicionando o botão de áudio
    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 140, 140)
    buttonPlay.x = display.contentWidth - 150
    buttonPlay.y = 200
    buttonPlay:addEventListener("touch", onTouch)

    -- Adicionando o ponto vermelho
    redPoint = display.newText(sceneGroup, "0", display.contentWidth - 50, 50, native.systemFontBold, 24)
    redPoint:setFillColor(1, 0, 0)

    -- Adicionando a nova imagem para shakePNG
    predioImage = display.newImageRect(sceneGroup, "assets/predio.png", largura, altura) -- Substitua largura e altura pelos valores desejados
    predioImage.x = display.contentCenterX
    predioImage.y = display.contentCenterY
end

-- Função para mostrar a cena
function scene:show(event)
    if event.phase == "did" then
        -- Iniciar o acelerômetro
        Runtime:addEventListener("accelerometer", onAccelerate)
    end
end

-- Função para ocultar a cena
function scene:hide(event)
    if event.phase == "did" then
        -- Parar o acelerômetro
        Runtime:removeEventListener("accelerometer", onAccelerate)
    end
end

-- Função para destruir a cena
function scene:destroy(event)
    if sound then
        audio.dispose(sound)
        sound = nil
    end
end

-- Adicionando os ouvintes de eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
