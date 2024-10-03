local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local player = {
    posX = screenWidth / 2,
    posY = screenHeight / 2,
    speed = 500
}

playerImage = love.graphics.newImage("res/Dog.png")
width = playerImage:getWidth()
height = playerImage:getHeight()

function love.update(dt)
    movePlayer(dt)
end

function love.draw()
    love.graphics.draw(playerImage, player.posX, player.posY)
end

function movePlayer(dt)
    if love.keyboard.isDown("w") then
        player.posY = player.posY - player.speed * dt
    end
    if love.keyboard.isDown("s") then
        player.posY = player.posY + player.speed * dt
    end
    if love.keyboard.isDown("a") then
        player.posX = player.posX - player.speed * dt
    end
    if love.keyboard.isDown("d") then
        player.posX = player.posX + player.speed * dt
    end
end
