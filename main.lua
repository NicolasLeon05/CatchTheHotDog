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
local win = false
local scoreToWin = 10
local missesToLose = 3

-- Scenes
local sceneMenu = true
local sceneGameplay = false
local sceneGameFinished = false

function love.load()
    -- Player
    player.image = love.graphics.newImage("res/Dog.png")
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()

    -- HotDog
    hotDogImage = love.graphics.newImage("res/HotDog.png")
    hotDogWidth = hotDogImage:getWidth() * scale
    hotDogHeight = hotDogImage:getHeight() * scale

    -- Fonts
    largeFont = love.graphics.newFont(48)
    mediumFont = love.graphics.newFont(24)
end

function love.update(dt)

    if sceneMenu then
        if love.keyboard.isDown("space") then
            initGame()
            sceneGameplay = true
            sceneMenu = false
        end

    elseif sceneGameplay then
        movePlayer(dt)
        generateHotDog(dt)
        checkEatHotDog()
        checkHotDogDespawn(dt)

        -- Check win/Lose-- Verificar si ha ganado o perdido
        if player.score >= scoreToWin then
            sceneGameplay = false
            win = true
        end

        if player.missed >= missesToLose then
            sceneGameplay = false
            win = false
        end
    end

end

function love.draw()
    if sceneMenu then
        drawMenu()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(largeFont)
        love.graphics.printf("Catch the Hot Dog", 0, love.graphics.getHeight() / 5, love.graphics.getWidth(), "center")
        love.graphics.setFont(mediumFont)
        love.graphics
            .printf("Press space to play", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")

    elseif sceneGameplay then
        -- Player
        love.graphics.draw(player.image, player.posX, player.posY)
        drawHotDogs()
        drawStats()
    else
        if win then
            love.graphics.printf("You Won!", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
        else
            love.graphics
                .printf("You Lost!", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
        end
    end
end

function initGame()
    player.score = 0
    player.missed = 0
    timeSinceLastSpawn = 0
    sceneMenu = true
    sceneGameplay = false
    sceneGameFinished = false
    win = false
    hotDog = {}
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()
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

function drawMenu()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(largeFont)
    love.graphics.printf("Catch the Hot Dog", 0, love.graphics.getHeight() / 5, love.graphics.getWidth(), "center")
    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press space to play", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

function drawHotDogs()
    for _, img in ipairs(hotDog) do
        love.graphics.draw(hotDogImage, img.x, img.y, 0, scale, scale)
    end
end

function drawStats()
    love.graphics.print("Eaten: " .. player.score, 10, 10)
    love.graphics.print("Missed: " .. player.missed, 10, 50)
end
