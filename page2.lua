local C = require('Constants')
local composer = require("composer")

-- Inclua a biblioteca LiquidFun
local liquidfun = require("plugin.liquidfun")

local scene = composer.newScene()



-- Configuração do mundo LiquidFun
local world

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Criação do mundo LiquidFun
    world = liquidfun.newWorld(0, 0)  -- Os parâmetros são a gravidade (0, 0) neste caso

    -- Adiciona um objeto para representar o planeta
    local planet = display.newCircle(sceneGroup, display.contentCenterX, display.contentCenterY, 150)
    planet:setFillColor(0, 0, 1)  -- Cor azul para representar o oceano

    -- Configuração do LiquidFun para o objeto do planeta
    local planetBody = liquidfun.newBody(world, planet.x, planet.y, "static")
    local planetShape = liquidfun.newCircleShape(0, 0, 150)
    local planetFixture = liquidfun.newFixture(planetBody, planetShape)

    -- Adiciona continentes
    createContinent(sceneGroup, 200, 150)
    createContinent(sceneGroup, 300, 300)
    createContinent(sceneGroup, 450, 100)

    -- Adiciona um ouvinte de evento de toque para simular o movimento dos continentes
    Runtime:addEventListener("touch", onTouch)
end

-- Função para criar continente
local function createContinent(parent, x, y)
    local continent = display.newRect(parent, x, y, 50, 50)
    continent:setFillColor(0, 1, 0)  -- Cor verde para representar o continente

    local continentBody = liquidfun.newBody(world, x, y, "dynamic")
    local continentShape = liquidfun.newRectangleShape(50, 50)
    local continentFixture = liquidfun.newFixture(continentBody, continentShape)
end

-- Função de toque para simular o movimento dos continentes
local function onTouch(event)
    if (event.phase == "began") then
        -- Aplica uma força nos continentes para simular o movimento
        applyForceToContinents()
    end
end

-- Função para aplicar uma força nos continentes
local function applyForceToContinents()
    for i = 1, scene.view.numChildren do
        local child = scene.view[i]
        if (child.body and child.body.type == "dynamic") then
            local forceX = math.random(-5, 5)
            local forceY = math.random(-5, 5)
            child.body:applyForce(forceX, forceY, child.x, child.y)
        end
    end
end

-- hide()
function scene:hide(event)
    local phase = event.phase

    if (phase == "did") then
        -- Remove o ouvinte de evento de toque ao sair da cena
        Runtime:removeEventListener("touch", onTouch)
    end
end

-- destroy()
function scene:destroy(event)
    -- Limpa o mundo LiquidFun
    world:destroy()
    world = nil
end

-- Scene event function listeners
scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
