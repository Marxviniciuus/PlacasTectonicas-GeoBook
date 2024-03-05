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

function scene:create( event )
 
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  local backgroundImage = display.newImageRect(sceneGroup, "assets/ContraCapa.png", display.contentWidth, display.contentHeight)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY


    local btNext = display.newImageRect(
    sceneGroup, "assets/seta.png", 64, 64
  )

  btNext.x = display.contentWidth - 710  -- Metade da largura da seta
  btNext.y = display.contentHeight - 70
  btNext.rotation = 270

  buttonPlay = display.newImageRect(sceneGroup, "assets/audio.png", 75, 75)
  buttonPlay.x, buttonPlay.y = display.contentWidth - 384, 930
  buttonPlay:addEventListener("touch", onTouch)

  function btNext.handle(event)
    composer.gotoScene("page7", {effect = "fromLeft", time = 1000})
  end

  btNext:addEventListener('tap', btNext.handle)

end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
      -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
      -- Code here runs when the scene is entirely on screen

  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
      -- Code here runs immediately after the scene goes entirely off screen

  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
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