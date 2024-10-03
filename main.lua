local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local player = {
    posX = screenWidth / 2,
    posY = screenHeight / 2,
    speed = 500,
    image,
    width,
    height
}

local hotDog = {image, width, height}

function love.load()
    -- Player
    player.image = love.graphics.newImage("res/Dog.png")
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()

    -- HotDog
    hotDog.image = love.graphics.newImage("res/HotDog.png")
    hotDog.width = hotDog.image:getWidth()
    hotDog.height = hotDog.image:getHeight()

end

function love.update(dt)
    movePlayer(dt)
end

function love.draw()
    love.graphics.draw(player.image, player.posX, player.posY)
    love.graphics.draw(hotDog.image, 100, 100, 0)
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
