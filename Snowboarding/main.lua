physics = require("physics")
physics.start()

physics.setGravity (0,0)
physics.setDrawMode("normal")

physics.setGravity(0,0)

display.setStatusBar (display.HiddenStatusBar)

-- Background
local bg = display.newImageRect("Imagens/bg.jpeg",298*10,169*10)    

 -- Player 
local player = display.newImageRect("Imagens/jinx.png",339/5,735/5)
player.x = display.contentCenterX
player.y = display.contentCenterY
physics.addBody(player,"kinematic", {isSensor = true})
player.isFixedRotation = true
player.myName = "player"

-- Buttons
local buttonleftdown = display.newImageRect("Imagens/button.png",225/1.5,225/1.5)
buttonleftdown.x = -40
buttonleftdown.y = display.contentHeight - 70
buttonleftdown.rotation = 145
buttonleftdown.myName = "buttonLD"

local buttonrightdown = display.newImageRect("Imagens/button.png",225/1.5,225/1.5)
buttonrightdown.rotation = 45
buttonrightdown.x = 80
buttonrightdown.y = display.contentHeight - 70
buttonrightdown.myName = "buttonRD"

-- Lives and Points
local score = 0
local HP = 5

-- Score
local n = 1
local scoreText = display.newText("Score: ".. score, -20, 100, native.systemFont, 60)
scoreText:setFillColor(1,0,0)
local HPText = display.newText("Lives left: ".. HP, display.contentWidth,100,native.systemFont,60)
HPText:setFillColor(0,1,1)

--Group Definition
local bggroup = display.newGroup()
local interactgroup = display.newGroup(player)
local controlgroup = display.newGroup(buttonleftdown,buttonrightdown)
local UIgroup = display.newGroup(HPText,scoreText)

local function placeRock()
    rockflag = math.random(1,2)
    -- Rock1
    if rockflag == 1 then
        local rock1 = display.newImageRect(interactgroup,"Imagens/rock2.png", 500/3,500/3)
        rock1.x = math.random(display.contentCenterX - 800,display.contentCenterX + 100)
        rock1.y = math.random(display.contentCenterY + 200,display.contentCenterY + 800)
        physics.addBody(rock1,"dynamic", {radius = 30 , isSensor = true})
        rock1.myName = "rock1"
        transition.to(rock1, {y = -500, time = 1400, onComplete = function() display.remove(rock1) end})
    -- Rock2
    else
        local rock2 = display.newImageRect(interactgroup,"Imagens/rock3.png", 220/1.5,178/1.5)
        rock2.x = math.random(display.contentCenterX - 800,display.contentCenterX + 100)
        rock2.y = math.random(display.contentCenterY + 200,display.contentCenterY + 800)
        physics.addBody(rock2,"dynamic", {radius = 30 , isSensor = true})
        rock2.myName = "rock2"
        transition.to(rock2, {y = -500, time = 1400, onComplete = function() display.remove(rock2) end})
    end
end

-- Flags
local n = 1
local rockflag = 0

-- Reset Player
local function resetPlayer()
    player.x = 0
    player.y = 0
    physics.addBody(player,"kinematic",{isSensor = true})
    player.isFixedRotation = true
    player.myName = "player"
end

--Player Immunity
local function playerImmunity()
    player.isBodyActive = false
    HP = HP - 1 
    HPText.text = "Lives left: ".. HP
    timer.performWithDelay( 1200 , function() player.isBodyActive = true end)
end

--Screens
local function gameOver()
    Runtime:removeEventListener("enterFrame",bgBorder)
    Runtime:removeEventListener("collision", damage)

    bgover = display.newRect(0,0,display.contentWidth + 1800 ,display.contentHeight + 1500)
    gameover = display.newText("Fim de Jogo", display.contentCenterX,display.contentCenterY,native.systemFont,90)
    gameover:setFillColor(1,0,0)
end
------------------------------------------

-- Score Gain
local function scoreGain()
    score = score + 1 
    scoreText.text = "Score: ".. score
    if score >= n*30 then
        HP = HP + 1 
        HPText.text = "Lives left: ".. HP
        n = n + 1
    end
end
------------------------

-- GameLoop
local function gameLoop()
    bg.y = bg.y + 3
    if playerCheck == false then
        playerImmunity()
        resetPlayer()
        playerCheck = true 
    end
    if HP <= 0 then
        gameOver()
    end
end
-------------------------


--BorderCheck
local function bgBorder()
    
    if bg.y >= display.contentHeight then
        bg.y = 0
    end

end

-- Movement ---------------
local function move(event)
    if (event.phase == "began" and event.target.myName == "buttonLD")then
        player:setLinearVelocity(-100,0)
    elseif (event.phase == "began" and event.target.myName == "buttonRD") then
        player:setLinearVelocity(100,0) 
    end
end

-- Damage Calculation
local function damage(event)
    if (event.object1.myName == "player" and event.object2.myName == "rock1") or  (event.object2.myName == "player" and event.object1.myName == "rock1") or 
    (event.object2.myName == "player" and event.object1.myName == "rock2") or (event.object1.myName == "player" and event.object2.myName == "rock2") then
        rockCheck = false
        playerCheck = false
    end
end
-- ----------------------------------


--Listeners and runtimes
timer.performWithDelay(math.random(1200,1400),placeRock,0)
Runtime:addEventListener("enterFrame",bgBorder)

buttonleftdown:addEventListener("touch",move)
buttonrightdown:addEventListener("touch",move)

Runtime:addEventListener("collision", damage)

timer.performWithDelay(0 , gameLoop ,0 )
timer.performWithDelay(1000,scoreGain,0)