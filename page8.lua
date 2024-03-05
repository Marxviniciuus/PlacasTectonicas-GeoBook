local C = require('Constants')
local composer = require("composer")

local scene = composer.newScene();

local isAudioPlaying = false
local buttonPlay
local sound


local function onTouch(event)
  if event.phase == "ended" then
      if isAudioPlaying then
          isAudioPlaying = false
          audio.stop()
          audio.dispose(sound)
      else
          isAudioPlaying = true
          sound = audio.loadSound("assets/audio/8audio.mp3")
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

function scene:create( event )
 
  local sceneGroup = self.view

  local backgroundImage = display.newImageRect(sceneGroup, "assets/ContraCapa.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY


    local btPreview = display.newImageRect(
    sceneGroup, "assets/seta.png", 64, 64
  )

  btPreview.x = display.contentWidth - 710
  btPreview.y = display.contentHeight - 70
  btPreview.rotation = 270
  btPreview:addEventListener("touch", function (event)
    if event.phase == "ended" then
        endAudio()
        composer.removeScene("page8")
        composer.gotoScene("page7", {effect = "fromLeft", time = 1000})
    end
  end)

  local btInicio = display.newImageRect(sceneGroup, "assets/inicio.png", 64, 64)
    btInicio.x, btInicio.y, btInicio.rotation = display.contentWidth - 60, display.contentHeight - 78
    btInicio:addEventListener("touch", function (event)
        if event.phase == "ended" then
            endAudio()
            composer.removeScene("page8")
            composer.gotoScene("page1", {time = 1000})
        end
    end)

  buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
  buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
  buttonPlay:addEventListener("touch", onTouch)

end

function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then

  elseif ( phase == "did" ) then

  end
end


function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then

  elseif ( phase == "did" ) then

  end
end

function scene:destroy( event )

  local sceneGroup = self.view
  sceneGroup:removeSelf()
  sceneGroup = nil

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene