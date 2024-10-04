-- Screen
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

-- Player
local player = {
    posX,
    posY,
    speed = 500,
    image,
    flip,
    width,
    height,
    score,
    missed
}

-- HotDogs
local hotDog = {}
local hotDogImage
local hotDogWidth
local hotDogHeight
local scale = 0.2
-- HotDogs timers
local lifeTime = 1
local spawnTime = 1
local timeSinceLastSpawn = 0

-- Win/Lose conditions
local win = false
local scoreToWin = 10
local missesToLose = 3

-- Scenes
local sceneMenu = true
local sceneGameplay = false
local sceneGameFinished = false

-- Backgrounds
local menuBackground
local gameplayBackground

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

    -- Backgrounds
    menuBackground = love.graphics.newImage("res/TitleScreen.jpg")
    gameplayBackground = love.graphics.newImage("res/GameScreen.jpg")
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
            sceneGameFinished = true
            win = true
        end

        if player.missed >= missesToLose then
            sceneGameplay = false
            sceneGameFinished = true
            win = false
        end
    elseif sceneGameFinished then
        if love.keyboard.isDown("escape") then
            sceneGameFinished = false
            sceneMenu = true
        elseif love.keyboard.isDown("space") then
            initGame()
            sceneGameFinished = false
            sceneMenu = false
            sceneGameplay = true
        end
    end
end

function love.draw()
    if sceneMenu then
        drawMenu()
    elseif sceneGameplay then
        drawGameplay()

    elseif sceneGameFinished then
        drawGameEnded()
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
    player.flip = 1 -- Looks to the right
    player.posX = screenWidth / 2 - player.width / 2
    player.posY = screenHeight / 2 - player.height / 2
end

function movePlayer(dt)
    if love.keyboard.isDown("w") then
        player.posY = player.posY - player.speed * dt
    end
    if love.keyboard.isDown("s") then
        player.posY = player.posY + player.speed * dt
    end
    if love.keyboard.isDown("a") then
        player.flip = 1
        player.posX = player.posX - player.speed * dt
    end
    if love.keyboard.isDown("d") then
        player.flip = -1
        player.posX = player.posX + player.speed * dt
    end
end

function checkCollision(player, hotDogX, hotDogY, hotDogWidth, hotDogHeight)
    return player.posX - player.width / 2 < hotDogX + hotDogWidth and player.posX + player.width / 2 > hotDogX and
               player.posY - player.height / 2 < hotDogY + hotDogHeight and player.posY + player.height / 2 > hotDogY
end

function spawnImage()
    local img = {}
    local spawnInPlayer = true

    -- Make sure the hotDog dosn't spawn inside the player
    while spawnInPlayer do
        img.x = math.random(0, love.graphics.getWidth() - hotDogWidth)
        img.y = math.random(0, love.graphics.getHeight() - hotDogHeight)

        if not checkCollision(player, img.x, img.y, hotDogWidth, hotDogHeight) then
            spawnInPlayer = false
        end
    end

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
    love.graphics.draw(menuBackground, 0, 0, 0, love.graphics.getWidth() / menuBackground:getWidth(),
        love.graphics.getHeight() / menuBackground:getHeight())
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(largeFont)
    love.graphics.printf("Catch the Hot Dog", 0, love.graphics.getHeight() / 5, love.graphics.getWidth(), "center")
    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press space to play", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

function drawGameplay()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameplayBackground, 0, 0, 0, love.graphics.getWidth() / gameplayBackground:getWidth(),
        love.graphics.getHeight() / gameplayBackground:getHeight())
    drawPlayer()
    drawHotDogs()
    love.graphics.setColor(0, 0, 0, 1)
    drawStats()
end

function drawPlayer()

    love.graphics.draw(player.image, player.posX, player.posY, 0, player.flip, 1, player.width / 2, player.height / 2)
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

function drawGameEnded()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameplayBackground, 0, 0, 0, love.graphics.getWidth() / gameplayBackground:getWidth(),
        love.graphics.getHeight() / gameplayBackground:getHeight())
    love.graphics.setColor(0, 0, 0, 1)
    if win then
        love.graphics.setFont(largeFont)
        love.graphics.printf("You Won!", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")

        love.graphics.setFont(mediumFont)
        love.graphics.printf("Press ESC to go to the menu or Space to restart", 0, love.graphics.getHeight() / 2 + 50,
            love.graphics.getWidth(), "center")
    else
        love.graphics.setFont(largeFont)
        love.graphics.printf("You Lost!", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")

        love.graphics.setFont(mediumFont)
        love.graphics.printf("Press ESC to go to the menu or Space to restart", 0, love.graphics.getHeight() / 2 + 50,
            love.graphics.getWidth(), "center")
    end
end
