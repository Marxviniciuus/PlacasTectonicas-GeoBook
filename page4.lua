local composer = require("composer")
local C = require('Constants')
system.activate( "multitouch" )
local physics = require( "physics" )

local scene = composer.newScene()
local isAudioPlaying = false
local buttonPlay
local sound
local rect1, rect2


local function onTouch(event)
    if event.phase == "ended" then
        if isAudioPlaying then
            isAudioPlaying = false
            audio.stop()
            audio.dispose(sound)
        else
            isAudioPlaying = true
            sound = audio.loadSound("assets/audio/4audio.mp3")
            audio.play(sound, { onComplete = function() isAudioPlaying = false end })
        end

        buttonPlay:removeEventListener("touch", onTouch)
        timer.performWithDelay(300, function()
            buttonPlay:addEventListener("touch", onTouch)
        end)
    end
end



function scene:create(event)
    local sceneGroup = self.view

    local backgroundImage = display.newImageRect(sceneGroup, "assets/Página3.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btNext.x, btNext.y, btNext.rotation = display.contentWidth - 60, display.contentHeight - 80, 90
    btNext:addEventListener('tap', function() composer.gotoScene("page5", {effect = "fromRight", time = 1000}) end)

    local btPreview = display.newImageRect(sceneGroup, "assets/seta.png", 64, 64)
    btPreview.x, btPreview.y, btPreview.rotation = display.contentWidth - 710, display.contentHeight - 80, 270
    btPreview:addEventListener('tap', function() composer.gotoScene("page3", {effect = "fromLeft", time = 1000}) end)

    buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
    buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
    buttonPlay:addEventListener("touch", onTouch)   

end

function scene:show(event)
   
end

function scene:hide(event)
    
end

function scene:destroy(event)
   
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
