--notes
--Linha azul é até onde o player se movimento
--GameState


local anim = require("lib/anim8")
local animation ,images

function love.load()


    -- O mouse não aparece dentro da janela
    love.mouse.setVisible(false)
    -- Pontuação de inimigos mortos
    score = 0
    -- Array para pegar outros elemetos do personagem/player
    player =  {}    
    
    --Vida do player
    player.hp = 10
    -- Velociadade do player
    player.Vel = 160    
    --Intervalo de ataque do player
    podeBater = true
    player.cdMax = 1
    -- DECLARANDO A POSIÇÃO DO PLAYER NA TELA JOGO
    player.x = 150
    player.y = 400 
    -- DECLANRANDO O TAMANHO DO PERSONAGEM/PLAYER NA TELA
    player.w = 96
    player.h = 186
    -- Instacia que manipula o lado das a sprites ser utilisado
    player.direction = "stop"
    -- Variaveis para guardar a ultima direção que o player esteve
    dRight = true   
    dLeft = false

    eAndando = false
    eAtacando = false
    --Um Array de inimigos
    enemys = {}
    SpawnList()
    -- enemys.direction = "right"
    -- Array(lista) para as imagens
    images = {}
    animation= {}
    -- Um arraylist para fonte de letra
    fonts = {}
    -- Uma fonte de letra
    fonts.large = love.graphics.newFont("assets/fonts/Gamer.ttf", 36)
    -- Fundo/Cenario
    images.background = love.graphics.newImage("assets/images/ground.png")
    -- Sprites do player
    images.player_weak_attack =  love.graphics.newImage("assets/images/protagonista_atacando.png")
    images.player_stop =  love.graphics.newImage("assets/images/protagonista_parado.png")
    images.player_walk =  love.graphics.newImage("assets/images/protagonista_andando.png")
    images.player_morte =  love.graphics.newImage("assets/images/protagonista_morte.png")
    --Sprites dos inimigos
        --Sprites dos inimigos andando
        images.enemy1_walk =  love.graphics.newImage("assets/images/capanga_andando_verde.png")
        images.enemy2_walk =  love.graphics.newImage("assets/images/capanga_andando_amarelo.png")
        images.enemy3_walk =  love.graphics.newImage("assets/images/capanga_andando_vermelho.png")
        images.enemy4_walk =  love.graphics.newImage("assets/images/capanga_musculoso_andando.png")
        --Sprites dos inimigos atacando
        images.enemy1_attack =  love.graphics.newImage("assets/images/capanga_verde_atacando.png")
        images.enemy2_attack =  love.graphics.newImage("assets/images/capanga_amarelo_atacando.png")
        images.enemy3_attack =  love.graphics.newImage("assets/images/capanga_vermelho_atacando.png")
        images.enemy4_attack =  love.graphics.newImage("assets/images/capanga_musculoso_atacando.png")
    
        images.enemy1_dead =  love.graphics.newImage("assets/images/capanga_morto_verde.png")

    
    -- Animação com o uso da biblioteca "anim8"
    -- Player
    local weak_attack = anim.newGrid(162, 204, images.player_weak_attack:getWidth(), images.player_weak_attack:getHeight())
    animation.weakAttack = anim.newAnimation( weak_attack('1-6', 1), 0.12)
    local pstop = anim.newGrid(96, 186, images.player_stop:getWidth(), images.player_stop:getHeight())
    animation.Stop = anim.newAnimation( pstop('1-2', 1), 0.25)
    local pwalk = anim.newGrid(94, 186, images.player_walk:getWidth(), images.player_walk:getHeight())
    animation.Walk = anim.newAnimation( pwalk('1-6', 1), 0.15)
    local pMorte = anim.newGrid(150, 186, images.player_walk:getWidth(), images.player_walk:getHeight())
    animation.Morte = anim.newAnimation( pMorte('1-3', 1), 0.15)
     -- -- Inimigos andando
     local e1walk = anim.newGrid(96, 168, images.enemy1_walk:getWidth(), images.enemy1_walk:getHeight())
     animation.e1Walk = anim.newAnimation( e1walk('1-7', 1), 0.10)
     local e2walk = anim.newGrid(96, 168, images.enemy2_walk:getWidth(), images.enemy2_walk:getHeight())
     animation.e2Walk = anim.newAnimation( e2walk('1-7', 1), 0.10)
     local e3walk = anim.newGrid(96, 168, images.enemy3_walk:getWidth(), images.enemy3_walk:getHeight())
     animation.e3Walk = anim.newAnimation( e3walk('1-7', 1), 0.10)
     local e4walk = anim.newGrid(156, 234, images.enemy4_walk:getWidth(), images.enemy4_walk:getHeight())
     animation.e4Walk = anim.newAnimation( e4walk('1-4', 1), 0.20)
     -- Ataque inimigos
     local e1attack = anim.newGrid(120, 168, images.enemy1_attack:getWidth(), images.enemy1_attack:getHeight())
     animation.e1Attack = anim.newAnimation( e1attack('1-4', 1), 0.20)
     local e2attack = anim.newGrid(120, 168, images.enemy2_attack:getWidth(), images.enemy2_attack:getHeight())
     animation.e2Attack = anim.newAnimation( e2attack('1-4', 1), 0.20)
     local e3attack = anim.newGrid(120, 168, images.enemy3_attack:getWidth(), images.enemy3_attack:getHeight())
     animation.e3Attack = anim.newAnimation( e3attack('1-4', 1), 0.20)
     local e4attack = anim.newGrid(264, 234, images.enemy4_attack:getWidth(), images.enemy4_attack:getHeight())
     animation.e4Attack = anim.newAnimation( e4attack('1-4', 1), 0.20)


     
 
     local e1dead = anim.newGrid(150, 174, images.enemy1_dead:getWidth(), images.enemy1_dead:getHeight())
     animation.e1Dead = anim.newAnimation( e1dead('1-3', 1), 0.20)

    
end

    
function love.update(dt)
    --Temporizador de ataque do player 
    player.cdMax = player.cdMax - dt
    if player.cdMax < 0 then
        podeBater = true
        player.cdMax = player.cdMax + 1 
    end
    if love.keyboard.isDown("q") then --Para Testes
        -- Chama o metodo de outro lugar
        enemySpawn(2, 300,400)
    end
    for i,v in ipairs(enemys) do 
        
        v.cdmax = v.cdmax - dt
        if v.cdmax < 0 then
            eAtacando  = true
            v.cdmax = v.cdmax + 1
        end
        
    end
    
    -- Chama o metodo de outro lugar
    fakeAI(dt)
    -- Chama o metodo de outro lugar
    movements(dt)
end
    

function love.draw()
    -- Fundo/Cenario
    for x=0, love.graphics.getWidth(), images.background:getWidth() do
        for y=0, love.graphics.getHeight(), images.background:getHeight() do
            love.graphics.draw(images.background, x, y)
        end
    end
    
    
    -- Inimigos
    for i,v in ipairs(enemys) do 
        if v.vida == 0 and eRight == true then
            animation.e1Dead:draw(images.enemy1_dead, v.x,v.y, 0, 1, 1, 90, 0)
        elseif v.vida == 0 and eLeft == true then
            animation.e1Dead:draw(images.enemy1_dead,v.x,v.y, 0, -1, 1,0, 0)
        end
    end
    --  Chama o metodo de outro lugar
    spritesAnimation()

    love.graphics.setFont(fonts.large)
    --mostra a pontuação do jogo
    love.graphics.print("SCORE: " .. score, 10, 10)
    love.graphics.print("HP= " .. player.hp,10,40)
    --Usar só para ver o range dos ataques
   -- love.graphics.setColor(0,1,1)
   -- for i,v in ipairs(enemys) do
    --if dLeft == true then
    -- love.graphics.rectangle("line",player.x-160,player.y,player.w-16,player.h-60)
    -- end
  -- if dRight == true then
    -- love.graphics.rectangle("line",player.x,player.y,player.w-16,player.h-60,v.x-96,v.y,v.h,v.w)
   --  end
    -- love.graphics.setColor(1,1,1)
end
end

--persegue o player :D
function fakeAI(dt)
    for i,v in ipairs(enemys) do
        distxt = player.x - v.x
        if distxt >= -800 and distxt <= 800 then
            if player.x > v.x and playerColid(player.x-96,player.y,player.w,player.h,v.x-96,v.y,v.h,v.w) == false and v.vivo == true then 
                distX = (player.x - 96) - (v.x-60)
                distY = player.y - (v.y)
                dist = math.sqrt(distX*distX+distY*distY)
                velX = distX/dist*v.vel
                velY = distY/dist*v.vel
                v.x = v.x + velX*dt
                v.y = v.y + velY*dt

                eLeft = false
                eRight = true
                eAndando = true
                
                for i,enemy in ipairs(enemys) do 
                    if  enemy.type == 1 then
                        animation.e1Walk:update(dt)
                    elseif enemy.type == 2 then
                        animation.e2Walk:update(dt)
                    elseif enemy.type == 3 then
                        animation.e3Walk:update(dt)
                    elseif enemy.type == 4 then
                        animation.e4Walk:update(dt)
                    end
                end
            end 
            if player.x < v.x and playerColid(player.x-96,player.y,player.w,player.h,v.x-96,v.y,v.h,v.w) == false and v.vivo == true then 
                distX = (player.x - 96) - (v.x + 20)
                distY = player.y - (v.y)
                dist = math.sqrt(distX*distX+distY*distY)
                velX = distX/dist*v.vel
                velY = distY/dist*v.vel
                v.x = v.x + velX*dt
                v.y = v.y + velY*dt
                eRight = false
                eLeft = true
                eAndando = true
            for i,enemy in ipairs(enemys) do 
                if  enemy.type == 1 then
                    animation.e1Walk:update(dt)
                elseif enemy.type == 2 then
                    animation.e2Walk:update(dt)
                elseif enemy.type == 3 then
                    animation.e3Walk:update(dt)
                elseif enemy.type == 4 then
                    animation.e4Walk:update(dt)
                end
            end
            end
            if v.vida <= 0 then
                --v.vivo = false
                animation.e1Dead:update(dt)
                table.remove(enemys,i)
                score = score + 1
            end

            --Ataque dos inimigos
            if playerColid(player.x-96,player.y,player.w,player.h,v.x-96,v.y,v.h,v.w) and eAtacando == true then
                eAndando = false
                -- for i,enemy in ipairs(enemys) do 
                --     if  enemy.type == 1 and eAtacando == true then
                --         animation.e1Attack:update(dt)
                --     elseif enemy.type == 2 and eAtacando == true then
                --         animation.e2Attack:update(dt)
                --     elseif enemy.type == 3 and eAtacando == true then
                --         animation.e1Attack:update(dt)
                --     elseif enemy.type == 4  and eAtacando == true then
                --         animation.e1Attack:update(dt)
                --     end
                -- end
                
                eAtacando = false
                player.hp = player.hp - v.dano
                if player.hp == 0 then
                    animation.Morte:update(dt)
                end
            end

        end
    end
end

    --Spawn
function enemySpawn(enemyType , enemyX , enemyY)
    --enemy type 1: Capangas Verdes, 2:Capanga Amarelos, 3: Capangas Vermelhos, 4: Boss
   -- if(player.x < spawnX)then
        if(enemyType == 1) then
            local enemy = {}
            enemy.atacando = true
            enemy.type = 1
            enemy.cdmax = 1
            enemy.dano = 1
            enemy.vivo = true
            enemy.vida = 3
            enemy.x = enemyX
            enemy.y = enemyY
            enemy.w = 96
            enemy.h = 168
            enemy.vel = 80
            table.insert(enemys,enemy)
        end
        if(enemyType == 2) then
            local enemy = {}
            enemy.atacando = true
            enemy.type = 2
            enemy.cdmax = 1
            enemy.dano = 1
            enemy.vivo = true
            enemy.vida = 6
            enemy.x = enemyX
            enemy.y = enemyY
            enemy.w = 96
            enemy.h = 168
            enemy.vel = 80
            table.insert(enemys,enemy)
            end
        if(enemyType == 3) then
            local enemy = {}
            enemy.atacando = true
            enemy.type = 3
            enemy.cdmax = 1
            enemy.dano = 1
            enemy.vivo = true
            enemy.vida = 9
            enemy.x = enemyX
            enemy.y = enemyY
            enemy.w = 96
            enemy.h = 168
            enemy.vel = 90
            table.insert(enemys,enemy)
        end 
        if(enemyType == 4) then
            local enemy = {}
            enemy.atacando = true
            enemy.type = 4
            enemy.cdmax = 1
            enemy.dano = 1
            enemy.vivo = true
            enemy.vida = 60
            enemy.x = enemyX
            enemy.y = enemyY
            enemy.w = 96
            enemy.h = 168
            enemy.vel = 80
            table.insert(enemys,enemy)
        end 
    --end
end

-- CONTROLES
function movements(dt)
    -- Se o player precionar seta para direita o personagem anda para a direita e ativa a animação
    if love.keyboard.isDown("right") then
        player.x = player.x + 150 * dt
        player.direction = "right"
        animation.Walk:update(dt)
        -- Se o player precionar seta para direita junto com a seta para cima
        -- o personagem anda pela direita para cima e ativa a animação
        -- tambem impede do personagem atravessar parte do cenario
        if love.keyboard.isDown("up") and player.y + player.h - 25 > 370 then 
            player.y = player.y - 150 * dt        
            player.direction = "right"
            animation.Walk:update(dt)
        end    
        -- Se o player precionar seta para direita junto com a seta para baixo
        -- o personagem anda pela direita para baixo e ativa a animação
        if love.keyboard.isDown("down") then
            player.y = player.y + 150 * dt        
            player.direction = "right"
            animation.Walk:update(dt)
        end  
        

    -- Se o player precionar seta para esquerda o personagem anda para a esquerda e ativa a animação
    elseif love.keyboard.isDown("left") then
        player.x = player.x - 150 * dt
        player.direction = "left"
        animation.Walk:update(dt)
        
        -- Se o player precionar seta para esquerda junto com a seta para cima
        -- o personagem anda pela direita para cima e ativa a animação
        -- tambem impede do personagem atravessar parte do cenario
        if love.keyboard.isDown("up") and player.y + player.h - 25 > 370 then 
            player.y = player.y - 150 * dt
            player.direction = "left"
            animation.Walk:update(dt)
        end
        -- Se o player precionar seta para direita junto com a seta para baixo
        -- o personagem anda pela direita para baixo e ativa a animação
        if love.keyboard.isDown("down") then
            player.y = player.y + 150 * dt        
            player.direction = "left"
            animation.Walk:update(dt)
        end
    -- Se o player precionar seta para cima o personagem anda para a cima e ativa a animação 
    -- e junto pega a variavel booleana para pega a ultima direção para o qual o personagem foi designado
    elseif love.keyboard.isDown("up") and player.y + player.h - 25 > 370 then 
        player.y = player.y - 150 * dt
        if dRight == true then
            player.direction = "right"
        else
            player.direction = "left"
        end
        animation.Walk:update(dt)
        
    -- Se o player precionar seta para baixo o personagem anda para a baixo e ativa a animação 
    -- e junto pega a variavel booleana para pega a ultima direção para o qual o personagem foi designado
    elseif love.keyboard.isDown("down") then  
        player.y = player.y + 150 * dt
        if dLeft == true then
            player.direction = "left"
        else
            player.direction = "right"
        end
        animation.Walk:update(dt)
    else
        player.direction = "stop"
        animation.Stop:update(dt)
    end

    --Ataque do player
    -- Apertando "e" ele usa o ataque fraco
    -- Caso um inimigo esteja proximo ele executa o metodo para atacar e remover o inimigo
        if love.keyboard.isDown("z") then
            if dRight == true then
                player.direction = "weakAttackRight"
            else
                player.direction = "weakAttackLeft"
            end
            animation.weakAttack:update(dt)
            if podeBater ==true then
                weakAttack()
            end
        end
        
    
    -- Metodo de ataque do player
    function weakAttack()
        for i,v in ipairs(enemys) do
            if love.keyboard.isDown("z") and dRight == true and podeBater == true then
                if playerColid(player.x,player.y,player.w-16,player.h-60,v.x-96,v.y,v.h,v.w) then
                    v.vida = v.vida - 3  
                end
                podeBater = false
            end   
            if love.keyboard.isDown("z") and dLeft == true and podeBater == true then  
                if playerColid(player.x-160,player.y,player.w-16,player.h-60,v.x-96,v.y,v.h,v.w) then
                    v.vida = v.vida - 3                  
                end
                podeBater = false
            end
        end
    end

end 

-- Animação das sprites onde tambem manipula a direção em que o personagem esta.
function spritesAnimation()
    -- Controle de sprites do Player
    if player.direction == "right" then
        -- Sprite virada para direita
        animation.Walk:draw(images.player_walk, player.x, player.y, 0, 1, 1, 90, 0)
        -- Sobrepoie a variavel e guarda para quando for nescessario 
        dRight = true
        dLeft = false
    elseif player.direction == "left" then
        -- Sprite virada para esquerda
        animation.Walk:draw(images.player_walk, player.x, player.y, 0, -1, 1, 0, 0)
        -- Sobrepoie a variavel e guarda para quando for nescessario 
        dRight = false
        dLeft = true
    -- Caso o player fique parado, ira acionar essa animação
    elseif  player.direction == "stop" and dRight == true then
        -- Sprite virada para direita
        animation.Stop:draw(images.player_stop, player.x, player.y, 0, 1, 1, 90, 0)
    elseif player.direction == "stop" and dLeft == true then
        -- Sprite virada para esquerda
        animation.Stop:draw(images.player_stop, player.x, player.y, 0, -1, 1, 0, 0)
    -- Caso o player ataque, ira acionar essa animação
    elseif  player.direction == "weakAttackRight" and dRight == true then
        -- Sprite virada para direita
        animation.weakAttack:draw(images.player_weak_attack, player.x, player.y, 0, 1, 1, 90, 18)
    elseif player.direction == "weakAttackLeft" and dLeft == true then
        -- Sprite virada para esquerda
        animation.weakAttack:draw(images.player_weak_attack, player.x, player.y, 0, -1, 1, 0, 18)
    -- Caso o player ataque, ira acionar essa animação
    elseif  player.hp <= 0  and dRight == true then
        -- Sprite virada para direita
        animation.Morte:draw(images.player_morte, player.x, player.y, 0, 1, 1, 90, 18)
    elseif player.hp <= 0  and dLeft == true then
        -- Sprite virada para esquerda
        animation.Morte:draw(images.player_morte, player.x, player.y, 0, -1, 1, 0, 18)
    end





    -- Inimigos
     for i,enemy in ipairs(enemys) do 
        -- Controle de sprites dos Inimigos
    if  enemy.type == 1 and eRight == true and eAndando == true then
        animation.e1Walk:draw(images.enemy1_walk, enemy.x,enemy.y, 0, 1, 1, 90, 0)
    elseif   enemy.type == 1 and eLeft == true then
        animation.e1Walk:draw(images.enemy1_walk,enemy.x,enemy.y, 0, -1, 1,0, 0)
    end
    if  enemy.type == 2 and eRight == true and eAndando == true then
        animation.e2Walk:draw(images.enemy2_walk, enemy.x,enemy.y, 0, 1, 1, 90, 0)
    elseif   enemy.type == 2 and eLeft == true then
        animation.e2Walk:draw(images.enemy2_walk,enemy.x,enemy.y, 0, -1, 1,0, 0)
    end
    if  enemy.type == 3 and eRight == true and eAndando == true then
        animation.e3Walk:draw(images.enemy3_walk, enemy.x,enemy.y, 0, 1, 1, 90, 0)
    elseif   enemy.type == 3 and eLeft == true then
        animation.e3Walk:draw(images.enemy3_walk,enemy.x,enemy.y, 0, -1, 1,0, 0)
    end
    if  enemy.type == 4 and eRight == true and eAndando == true then
        animation.e4Walk:draw(images.enemy4_walk, enemy.x,enemy.y, 0, 1, 1, 90, 49)
    elseif   enemy.type == 4 and eLeft == true then
        animation.e4Walk:draw(images.enemy4_walk,enemy.x,enemy.y, 0, -1, 1,0, 49)
    end


    -- if  enemy.type == 1 and eAtacando == true and eRight == true then
    --     animation.e1Attack:draw(images.enemy1_attack, enemy.x,enemy.y, 0, 1, 1, 90, 0)
    -- elseif   enemy.type == 1 and eAtacando == true and eLeft == true then
    --     animation.e1Attack:draw(images.enemy1_attack,enemy.x,enemy.y, 0, -1, 1,0, 0)
    -- end


    -- if  enemy.type == 2 and eAtacando == true and eRight == true then
    --     animation.e2Attack:draw(images.enemy2_attack,enemy.x,enemy.y, 0, 1, 1, 90, 0)
    -- elseif   enemy.type == 2 and eAtacando == true and eLeft == true  then
    --     animation.e2Attack:draw(images.enemy2_attack,enemy.x,enemy.y, 0, -1, 1,0, 0)
    -- end

    -- for i,ene in ipairs(enemys) do 
        -- for i,enemy in ipairs(enemys) do 
        
        -- end
    -- end
    end

end


function playerColid(x1, y1, w1, h1, x2, y2, h2, w2)
    return  x1 < x2 + w2 and
            x1 + w1 > x2 and 
            y1 < y2 + h2 and
            y1 + h1 > y2
end
    
function SpawnList()
    
end
    
    