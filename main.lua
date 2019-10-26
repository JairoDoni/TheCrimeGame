--notes
--Linha azul é até onde o player se movimento
--GameState


function love.load()
score = 00000

player =  {}
player.Vel = 160    
player.x = 150
player.y = 400 
player.l = 50
player.h = 100
--esquerda-1 direita-2 
player.side = 1

enemys = {}

end
function love.draw()
love.graphics.setColor(1,0,0)
for i,v in ipairs(enemys) do 
    love.graphics.rectangle("fill",v.x,v.y,v.l,v.h)
end
love.graphics.setColor(0,0,1)
love.graphics.line(0,250,800,250)
love.graphics.setColor(0,1,0)
love.graphics.rectangle("fill",player.x,player.y,player.l,player.h)


--Usar só para ver o range dos ataques
--love.graphics.setColor(0,1,1)
--if player.side == 1 then
--love.graphics.rectangle("line",player.x-25,player.y+30,player.l/2,player.h/2)
--end
--if player.side == 2 then
--love.graphics.rectangle("line",player.x+50,player.y+30,player.l/2,player.h/2)
--end

end

function love.update(dt)
playerMov(dt)
if love.keyboard.isDown("q") then --Para Testes
    enemySpawn()
    end
    fakeAI(dt)
end



--persegue o player :D
function fakeAI(dt)
for i,v in ipairs(enemys) do
    if player.x > v.x and playerColid(player.x,player.y,player.l,player.h,v.x,v.y,v.h,v.l) == false then 
        distX = player.x - (v.x+55)
        distY = player.y - (v.y)
        dist = math.sqrt(distX*distX+distY*distY)
        velX = distX/dist*v.vel
        velY = distY/dist*v.vel
        v.x = v.x + velX*dt
        v.y = v.y + velY*dt
    end
    if player.x < v.x and playerColid(player.x,player.y,player.l,player.h,v.x,v.y,v.h,v.l) == false then 
        distX = player.x - (v.x-55)
        distY = player.y - (v.y)
        dist = math.sqrt(distX*distX+distY*distY)
        velX = distX/dist*v.vel
        velY = distY/dist*v.vel
        v.x = v.x + velX*dt
        v.y = v.y + velY*dt
    end
end

end
--Spawn
function enemySpawn()
local enemy = {}

enemy.x = 200
enemy.y = 250
enemy.l = 50
enemy.h = 100
enemy.vel = 80
table.insert(enemys,enemy)
end

--Movimento do Player
function playerMov(dt)
    if love.keyboard.isDown("d") then
        player.x = player.x + (player.Vel * dt)
        player.side = 2
    end
    if love.keyboard.isDown("s") then
            player.y = player.y + (player.Vel * dt)
    end
    if love.keyboard.isDown("a") then
            player.x = player.x - (player.Vel * dt)
            player.side = 1
    end
    if love.keyboard.isDown("w") and player.y + player.h - 25 > 250 then
            player.y = player.y - (player.Vel * dt)
    end
    --Ataque do player
        for i,v in ipairs(enemys) do
            
    if love.keyboard.isDown("e") and player.side == 1 and playerColid(player.x-25,player.y+30,player.l,player.h,v.x,v.y,v.h,v.l) or love.keyboard.isDown("e") and player.side == 2 and playerColid(player.x+50,player.y+30,player.l,player.h,v.x,v.y,v.h,v.l) then
            table.remove(enemys,enemy)
        end
    end
end

function playerColid(x1, y1, l1, h1, x2, y2, h2, l2)
    return  x1 < x2 + l2 and
            x1 + l1 > x2 and 
            y1 < y2 + h2 and
            y1 + h1 > y2
end



