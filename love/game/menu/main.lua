BUTTON_HEIGHT = 64
function newButton(text, fn)
    return{
        text = text,
        fn = fn,

        now = false,
        last = false
    }
end 
local buttons = {}

function love.load()
    loadMenu()
    
end
function love.update()
end
function love.draw()
    drawMenu()
end

function loadMenu()
    images = {}
    images.backgroundMenu = love.graphics.newImage("fundomenu04_1.png")
    fonts = {}
    fonts.gobold = love.graphics.newFont("gobold.otf", 36)
    table.insert(buttons, newButton(
        "Start Game",
        function()
            print("Starting Game")
        end))
    table.insert(buttons, newButton(
        "Exit",
        function()
            love.event.quit(0)
        end))
end
function drawMenu()
    for x=0, love.graphics.getWidth(), images.backgroundMenu:getWidth() do
        for y=0, love.graphics.getHeight(), images.backgroundMenu:getHeight() do
            love.graphics.draw(images.backgroundMenu, x, y)
        end
    end
    
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    local margin = 16

    local button_width = windowWidth * (1/3)

    local total_heigh = (BUTTON_HEIGHT + margin) * #buttons
    local cursor_y = 0



    for i, button in ipairs(buttons) do
        button.last = button.now
        local bx = (windowWidth * 0.5) - (button_width * 0.5)
        local by = (windowHeight * 0.77) - (total_heigh * 0.77) + cursor_y

        local color = {0.2, 0.2, 0.2, 1.0}

        local mx, my = love.mouse.getPosition()

        local hot = mx > bx and mx < bx + button_width and
                    my > by and my < by + BUTTON_HEIGHT

        if hot then
            color = {0.5, 0.5, 0.5, 1.0}
        end
        button.now = love.mouse.isDown(1)
        if button.now and not button.last and hot then
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            bx,
            by,
            button_width,
            BUTTON_HEIGHT
        )
        love.graphics.setColor(1, 1, 1)
        
   
        local textW = fonts.gobold:getWidth(button.text)
        local textH = fonts.gobold:getHeight(button.text)
        love.graphics.print(
            button.text,
            fonts.gobold,
            (windowWidth * 0.5) - textW * 0.5,
            by + textH * 0.2
        )
        
        
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end
end