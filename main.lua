-- Screen
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

-- Player
local player = {
    posX = screenWidth / 2,
    posY = screenHeight / 2,
    speed = 500,
    image,
    width,
    height
}

-- HotDogs
local hotDog = {}
local hotDogImage
local hotDogWidth
local hotDogHeight
local scale = 0.2

function love.load()
    -- Player
    player.image = love.graphics.newImage("res/Dog.png")
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()

    -- HotDog
    hotDogImage = love.graphics.newImage("res/HotDog.png")
    hotDogWidth = hotDogImage:getWidth() * scale
    hotDogHeight = hotDogImage:getHeight() * scale
end

function love.update(dt)
    movePlayer(dt)
    spawnImage()
end

function love.draw()
    -- Player
    love.graphics.draw(player.image, player.posX, player.posY)

    -- HotDogs
    for _, img in ipairs(hotDog) do
        love.graphics.draw(hotDogImage, img.x, img.y, 0, scale, scale)
    end
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

function spawnImage()
    local img = {}
    img.x = math.random(0, love.graphics.getWidth() - hotDogWidth)
    img.y = math.random(0, love.graphics.getHeight() - hotDogHeight)
    table.insert(hotDog, img)
end
