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
          sound = audio.loadSound("assets/audio/1audio.mp3")
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

  local backgroundImage = display.newImageRect(sceneGroup, "assets/Capa.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY


  local btNext = display.newImageRect(
    sceneGroup, "assets/seta.png", 64, 64
  )

  btNext.x = display.contentWidth - 60
  btNext.y = display.contentHeight - 67
  btNext.rotation = 90

  buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
  buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
  buttonPlay:addEventListener("touch", onTouch)

  local btNext = display.newImageRect(sceneGroup, "assets/seta.png", 64, 60)
  btNext.x, btNext.y, btNext.rotation = display.contentWidth - 60, display.contentHeight - 67, 90
  btNext:addEventListener("touch", function (event)
    if event.phase == "ended" then
        endAudio()
        composer.removeScene("page1")
        composer.gotoScene("page2", {effect = "fromRight", time = 1000})
    end
end)

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


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene