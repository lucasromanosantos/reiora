local anim8 = require "lib/anim8"

function startPlayer()

	local sprites = love.graphics.newImage("images/characters.png")
	local grid = anim8.newGrid(32, 32, sprites:getWidth(), sprites:getHeight(), 96, 128, 0) --offset

	player = {
		sprites = sprites,
		x = 256,
		y = 256,
		x_vel = 0,
		y_vel = 0,
		speed = 250,
		jumpspeed = -450,
		w = 32,
		h = 32,
		jumping = false,
		animations = {
			idle = anim8.newAnimation(grid('1-3', 1), 1.0),
			left = anim8.newAnimation(grid('1-3', 2), 0.1),
			right = anim8.newAnimation(grid('1-3', 3), 0.1)
		}
	}
	player.animation = player.animations.idle

	gravity =  9.81*70
	friction = 10
end

function movePlayer(dt, world)
	local down = love.keyboard.isDown

	if down("a", "left") then
		player.x_vel = -1 * player.speed
		player.animation = player.animations.left
	end
	if down("d", "right") then
		player.x_vel = player.speed
		player.animation = player.animations.right
	end
	if down("w", "up") then
		if not player.jumping then
			player.y_vel = player.jumpspeed
			player.jumping = true
			player.animation = player.animations.idle
		end
	end
	player.x, player.y, cols, len = world:move(player, player.x + (player.x_vel * dt), player.y + (player.y_vel * dt))
	for i=1, len do
		local col = cols[i]
		checkIfOnGround(col.normal.y)
	end

	player.animation:update(dt)

	player.y_vel = player.y_vel + (gravity * dt)
	if player.x_vel < 0 then
		player.x_vel = player.x_vel + friction
	end
	if player.x_vel > 0 then
		player.x_vel = player.x_vel - friction
	end
end

function checkIfOnGround(ny)
	if ny < 0 then
		player.jumping = false
		player.y_vel = 0 --?
	end
end