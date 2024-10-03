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
    height,
    score = 0,
    missed = 0
}

-- HotDogs
local hotDog = {}
local hotDogImage
local hotDogWidth
local hotDogHeight
local scale = 0.2
-- HotDogs timers
local lifeTime = 1.5
local spawnTime = 1.5
local timeSinceLastSpawn = 0

-- Win/Lose conditions
local gameEnded = false
local scoreToWin = 10
local missesToLose = 3

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
    if not gameEnded then

        movePlayer(dt)

        generateHotDog(dt)

        checkEatHotDog()

        checkHotDogDespawn(dt)

        -- Check win/Lose-- Verificar si ha ganado o perdido
        if player.score >= scoreToWin then
            gameEnded = true
        end

        if player.missed >= missesToLose then
            gameEnded = true
        end
    end

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

function checkCollision(player, hotDogX, hotDogY, hotDogWidth, hotDogHeight)
    return player.posX < hotDogX + hotDogWidth and player.posX + player.width > hotDogX and player.posY < hotDogY +
               hotDogHeight and player.posY + player.height > hotDogY
end

function spawnImage()
    local img = {}
    img.x = math.random(0, love.graphics.getWidth() - hotDogWidth)
    img.y = math.random(0, love.graphics.getHeight() - hotDogHeight)
    img.time = 0
    table.insert(hotDog, img)
end

function generateHotDog(dt)
    timeSinceLastSpawn = timeSinceLastSpawn + dt
    if timeSinceLastSpawn >= spawnTime then
        spawnImage()
        timeSinceLastSpawn = 0
    end
end

function checkEatHotDog()
    for i = #hotDog, 1, -1 do
        if checkCollision(player, hotDog[i].x, hotDog[i].y, hotDogWidth, hotDogHeight) then
            table.remove(hotDog, i)
            player.score = player.score + 1
        end
    end
end

function checkHotDogDespawn(dt)
    for i, img in ipairs(hotDog) do
        img.time = img.time + dt
        if img.time >= lifeTime then
            table.remove(hotDog, i)
            player.missed = player.missed + 1
        end
    end
end
