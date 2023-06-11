physics = require("physics")
physics.start()

physics.setGravity (0,0)
physics.setDrawMode("normal")

display.setStatusBar (display.HiddenStatusBar)

-- Background
local bg = display.newImageRect("Imagens/Space-Background-Images.jpg",2000/1,1333*1.5)

-- Player 
local player = display.newImageRect("Imagens/images.png",225/4,225/4)
player.x = display.contentCenterX
player.y = 180
physics.addBody(player,"kinematic", {isSensor = true})
player.isFixedRotation = true
player.myName = player

-- Enemy
local enemy = display.newImageRect("Imagens/aaaaa_xcom.png", 360/8,760/12)
enemy.x = display.contentCenterX + 90
enemy.y = display.contentCenterY
physics.addBody(enemy,"dynamic", {radius = 10 , isSensor = true})
enemy.myName = enemy

-- Buttons
local buttonup = display.newImageRect("Imagens/button.png",1279/20,1280/20)
buttonup.x = 90
buttonup.y = display.contentHeight - 120
buttonup.rotation = 90
buttonup.myName = "buttonU"

local buttondown = display.newImageRect("Imagens/button.png",1279/20,1280/20)
buttondown.rotation = 270
buttondown.x = 90
buttondown.y = display.contentHeight - 30
buttondown.myName = "buttonD"

local buttonleft = display.newImageRect("Imagens/button.png",1279/20,1280/20)
buttonleft.rotation = 0
buttonleft.x = 30
buttonleft.y = display.contentHeight - 75
buttonleft.myName = "buttonL"

local buttonright = display.newImageRect("Imagens/button.png",1279/20,1280/20)
buttonright.rotation = 180
buttonright.x = 150
buttonright.y = display.contentHeight - 75
buttonright.myName = "buttonR"

local fire = display.newImageRect("Imagens/Fire.png",512/9,512/9)
fire.x = 150
fire.y = display.contentHeight - 160

-- Lives and Points
local score = 0
local HP = 5

--Group Definition
local bggroup = display.newGroup(bg)
local interactgroup = display.newGroup(enemy,player)
local controlgroup = display.newGroup(buttonup,buttondown,buttonleft,buttonright,fire)
local UIgroup = display.newGroup()

-- Score
local n = 1
local scoreText = display.newText("Score: ".. score, display.contentWidth - 70, display.contentHeight - 50, native.systemFont, 30)
scoreText:setFillColor(0,1,1)
local HPText = display.newText("Lives left: ".. HP, 80,100,native.systemFont,30)
HPText:setFillColor(1,0,0)



-- Flags
local returning = false
local enemyCheck = true
local playerCheck = true

-- Reset Player
local function resetPlayer()
    player.x = display.contentCenterX - 240
    player.y = -170
    physics.addBody(player,"kinematic")
    player.isFixedRotation = true
    player.myName = player
end

--Player Immunity
local function playerImmunity()
    player.isBodyActive = false
    HP = HP - 1 
    HPText.text = "Lives left: ".. HP
    timer.performWithDelay( 1000 , function() player.isBodyActive = true end)
end

--Screens
local function gameOver()
    Runtime:removeEventListener("enterFrame",walking)
    Runtime:removeEventListener("enterFrame",checkBorder)
    Runtime:removeEventListener("collision", damage)

    bgover = display.newRect(0,0,display.contentWidth + 900 ,display.contentHeight + 1000)
    gameover = display.newText("Game Over...\n".. "Your Score is: ".. score, display.contentCenterX,display.contentCenterY,native.systemFont,40)
    gameover:setFillColor(1,0,0)
end

----------------------

local function gameLoop()
    if playerCheck == false then
        playerImmunity()
        resetPlayer()
        playerCheck = true 
        if projectileEnemy ~= nil then
            display.remove(projectileEnemy)  
        end
    end
    if HP <= 0 then
        gameOver()
    end
end

-- Reset Enemy
local function resetEnemy()
    physics.addBody(enemy,"dynamic",{radius = 10, isSensor = true})
    enemy.x = 60
    enemy.y = math.random(display.contentHeight - 900, display.contentHeight - 500)
    enemy:setLinearVelocity(math.random(-50,80),0)
    enemy.myName = enemy
end
-----------------------

-- Velocity Setting - Enemy
local function walking()
    if enemyCheck == false then
        resetEnemy()
        enemyCheck = true
    end
    if (enemy.x > display.contentWidth - 50 or enemy.x < -600 and returning == false) then
        vx = -vx
        returning = true
        vx,vy = enemy:getLinearVelocity()
    else
        returning = false
    end
    enemy:setLinearVelocity(vx + math.random(40.0,80.0),0)
end

local function checkBorder()
            
    if enemy.x > display.contentWidth - 50 then
        vx = -vx
        enemy:setLinearVelocity(vx,0)
        vx,vy = enemy:getLinearVelocity()
    end

end

enemy:setLinearVelocity(math.random(30,60),0)
vx,vy = enemy:getLinearVelocity()

-- Movement ---------------
local function move(event)
    if (event.phase == "began" and event.target.myName == "buttonU")then
        player:setLinearVelocity(0,-90)
    elseif (event.phase == "began" and event.target.myName == "buttonR") then
        player:setLinearVelocity(90,0) 
    elseif (event.phase == "began" and event.target.myName == "buttonD") then
        player:setLinearVelocity(0,90) 
    elseif (event.phase == "began" and event.target.myName == "buttonL") then
        player:setLinearVelocity(-90,0) 
    elseif (event.phase == "ended" or event.phase == "cancelled") then
        player:setLinearVelocity(0,0)
    end
end
------------------------------------------

-- Projectile Generation
local function resetProj()
    projectile = display.newImageRect(interactgroup,"Imagens/projectile.png",225/3.5,225/3.5)
    projectile.x = -1000
    projectile.y = -1000
    physics.addBody(projectile,"dynamic", {radius = 20, isSensor = true})
    projectile.isFixedRotation = true
    projectile.isBullet = true
    projectile.myName = projectile
end

local function resetProjEnemy()
    projectileEnemy = display.newImageRect(interactgroup,"Imagens/projectile.png",225/3.5,225/3.5)
    projectileEnemy.x = -1000
    projectileEnemy.y = -1000
    physics.addBody(projectileEnemy,"dynamic", {radius = 20, isSensor = true})
    projectileEnemy.isFixedRotation = true
    projectileEnemy.isBullet = true
    projectileEnemy.myName = projectileEnemy
    projectileEnemy:setFillColor(0.8,0.1,0.2)
end

----------------------------------

-- Damage Calculation
local function damage(event)
    if (event.object1.myName == projectile and event.object2.myName == enemy) or  (event.object2.myName == projectile and event.object1.myName == enemy) and event.phase == "began" then
        score = score + 20
        scoreText.text = "Score: "..score
        projectile:removeSelf() 
        enemyCheck = false
        
        if score == n*100 then
            HP = HP + 1 
            HPText.text = "Lives left: ".. HP
            n = n + 1
        end

    end
    if (event.object1.myName == player and event.object2.myName == enemy) or  (event.object2.myName == player and event.object1.myName == enemy) or 
    (event.object2.myName == player and event.object1.myName == projectileEnemy) or (event.object1.myName == player and event.object2.myName == projectileEnemy) and event.phase == "began" then
        enemyCheck = false
        playerCheck = false
    end
    if (event.object2.myName == projectile and event.object1.myName == projectileEnemy) or 
    (event.object1.myName == projectile and event.object2.myName == projectileEnemy) then
        display.remove(projectileEnemy)
        display.remove(projectile)
    end
end
----------------------------------

local function fireProj(event)
    if (event.phase == "began") then
        resetProj()
        projectile.x = player.x
        projectile.y= player.y + 20
        timer.performWithDelay(800,transition.to(projectile,{y = display.contentHeight, time = 1200, onComplete = function() display.remove(projectile) end}))
    end
end

local function enemyProj()
    resetProjEnemy()
    projectileEnemy.x = enemy.x
    projectileEnemy.y= enemy.y - 30
    transition.to(projectileEnemy,{y = -700, time = 900, onComplete = function() display.remove(projectileEnemy) end})
end

Runtime:addEventListener("enterFrame",walking)
Runtime:addEventListener("enterFrame",checkBorder)

buttonup:addEventListener("touch",move)
buttondown:addEventListener("touch",move)
buttonright:addEventListener("touch",move)
buttonleft:addEventListener("touch",move)

fire:addEventListener("touch",fireProj)

Runtime:addEventListener("collision", damage)

timer.performWithDelay(0 , gameLoop ,0 )
enemy.timer = timer.performWithDelay(math.random(1100,1800), enemyProj, 0)