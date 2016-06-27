local bump = require "lib/bump"
local gamera = require "lib/gamera" 
require "map-functions"
require "player"
require "enemy"
require "skills"
local anim8 = require "lib/anim8"

world = bump.newWorld()
blocks = {}

screen_width = 1028
screen_height = 720

lifebar_const = 3

local function addBlock(x,y,w,h)
	local block = {x=x,y=y,w=w,h=h}
	blocks[#blocks+1] = block
	world:add(block, x,y,w,h)
end

function love.load()
	cam = gamera.new(0, 0, 1080*32, 768*32)
    cam:setWorld(0, 0, 1080*32, 768*32)
    cam:setWindow(0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	background = love.graphics.newImage("images/background0.png")
	loadMap("maps/map2.lua")
	startPlayer()
	startEnemy()
 	world:add(player, player.x, player.y, player.w, player.h)
 	world:add(enemy, enemy.x, enemy.y, enemy.w, enemy.h)


end

function love.update(dt)
	movePlayer(dt, world)
	moveEnemy(dt, world)
	--updateSkill(dt)

	player.skill_timeout = math.max ( 0, player.skill_timeout - dt )
	world:move(player, player.x + (player.x_vel * dt), player.y + (player.y_vel * dt))
end

function love.draw()
	cam:draw(function(l,t,w,h)
        cam:setPosition(player.x, player.y)
        cam:setScale(1.0)
    	


	for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end
	drawMap()

	player.animation:draw(player.sprites, player.x, player.y, player.r, 1, 1, 0, 0)
	for i, skill in ipairs(player.skills) do
		skill.animation:draw(skill.sprites, skill.x, skill.y, skill.r, 1, 1, 0, 0)
	end






	enemy.animation:draw(enemy.sprites, enemy.x, enemy.y, enemy.r, 1, 1, 0, 0)
	--
	love.graphics.print("Sprite Position: (" .. player.x .. " , " .. player.y .. ")", 38, 75) 
	love.graphics.print("x_vel = " .. player.x_vel .. ", y_vel = " .. player.y_vel, 38, 85)
	if player.jumping then
		love.graphics.print("Jumping!", 38, 96)
	end
	-- love.graphics.print("Player lifebar: " .. player.lifebar, 38, 86)
	--love.graphics.print("Enemy lifebar: " .. enemy.lifebar, 500, 86)

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("line", screen_width * 5 / 100 , screen_height * 5 / 100, 100 * lifebar_const, 20 )
	love.graphics.rectangle("line", screen_width * 45 / 100 , screen_height * 5 / 100, 100 * lifebar_const, 20 )
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", screen_width * 5 / 100 , screen_height * 5 / 100, player.lifebar * lifebar_const, 20 )
	love.graphics.rectangle("fill", screen_width * 45 / 100 , screen_height * 5 / 100, enemy.lifebar * lifebar_const, 20 )
	love.graphics.setColor(255,255,255) -- reset colours

	love.graphics.print("Enemy lifebar: " .. enemy.lifebar, 500, 86)

        
    end)


end