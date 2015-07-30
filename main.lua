local bump = require "lib/bump"
require "map-functions"
require "player"
local anim8 = require "lib/anim8"

world = bump.newWorld()
blocks = {}

local function addBlock(x,y,w,h)
	local block = {x=x,y=y,w=w,h=h}
	blocks[#blocks+1] = block
	world:add(block, x,y,w,h)
end

function love.load()
	loadMap("maps/map1.lua")
	
	startPlayer()
 	world:add(player, player.x, player.y, player.w, player.h)

end

function love.update(dt)
	movePlayer(dt, world)
end

function love.draw()
	drawMap()
	player.animation:draw(player.sprites, player.x, player.y, player.r, 1, 1, 0, 0)
	--
	love.graphics.print("Sprite Position: (" .. player.x .. " , " .. player.y .. ")", 38, 36) 
	love.graphics.print("x_vel = " .. player.x_vel .. ", y_vel = " .. player.y_vel, 38, 56)
	if player.jumping then
		love.graphics.print("Jumping!", 38, 76)
	end
end