physics = require("physics")
physics.start()

display.setStatusBar(display.HiddenStatusBar)
physics.setGravity (0.01,0.01)

-- Criação do círculo
local circle = display.newCircle (display.contentCenterX, display.contentCenterY, 20)
physics.addBody(circle,"dynamic", {friction = 0, bounce = 1.05, density = 1})

-- Definição de velocidade
circle:setLinearVelocity(math.random(20,100),math.random(20,100))
local velx,vely = circle:getLinearVelocity()

-- Condição para colocar inversão de velocidade
if (velx < 50) then
    circle:setLinearVelocity(-velx * 2, vely)
end
if (vely < 50 ) then
    circle:setLinearVelocity(velx, -vely * 2)

end

-- Definição das bordas
local ladoesq = display.newRect (0,0,5,1500)
physics.addBody(ladoesq,"static")
local ladodir = display.newRect (display.contentWidth,0,5,1500)
physics.addBody(ladodir,"static")
local cima = display.newRect (0,0,1500,5)
physics.addBody(cima,"static")
local baixo = display.newRect (0,display.contentHeight,1500,5)
physics.addBody(baixo,"static")

-- Função de aleatorização de cores por colisão
local function corlisao(event)
    colors = {math.random(),math.random(),math.random()}
    event.target:setFillColor(colors[1],colors[2],colors[3])
    if colors == {1,1,1} then
        event.target:setFillColor(0,0,0)
    end
end


circle:addEventListener("collision",corlisao)