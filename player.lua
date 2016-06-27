local anim8 = require "lib/anim8"

function startPlayer()
	local sprites = love.graphics.newImage("images/reiorafull.png")
	local grid = anim8.newGrid(48, 84, sprites:getWidth(), sprites:getHeight()) --offset

	player = {
		lifebar = 100,
		isPlayer = true,
		sprites = sprites,
		x = 256,
		y = 256,
		x_vel = 0,
		y_vel = 0,
		speed = 200,
		jumpspeed = -500,
		w = 34,
		h = 84,
		jumping = false,
		facing = "right",
		animations = {
			idler = anim8.newAnimation(grid('1-4', 1), 0.7),
			idlel = anim8.newAnimation(grid('1-4', 3), 0.7),
			left = anim8.newAnimation(grid('1-4', 4), 0.2),
			right = anim8.newAnimation(grid('1-4', 2), 0.2),
			atack = anim8.newAnimation(grid('1-1', 1), 0.5)
		},
		skills = {},
		skill_timeout = 0.5
	}
	player.animation = player.animations.idler

	gravity =  9.81*70
	friction = 20

end

function movePlayer(dt, world)
	local down = love.keyboard.isDown

	if down("a", "left") then
		player.x_vel = -1 * player.speed
		player.animation = player.animations.left
		player.facing = "left"
	elseif down("d", "right") then
		player.x_vel = player.speed
		player.animation = player.animations.right
		player.facing = "right"
	elseif down("w", "up") then
		if not player.jumping then
			player.y_vel = player.jumpspeed
			player.jumping = true
			player.animation = player.animations.idler
		end
	elseif down("q") and player.skill_timeout == 0 then
--		player.animation = player.animations.atack
		useSkill()
		player.skill_timeout = 0.50
	else
		if player.facing == "right" then
			player.animation = player.animations.idler
		else
			player.animation = player.animations.idlel
		end
	end
	
	

	local playerFilter = function(item, other)
		if other.isEnemy then return nil
		elseif other.isSkill then return nil
		end
		return 'slide'
		--if other.isSkill then return nil
		--elseif other.isEnemy then return nil
		--else return 'slide'
		--end
	end
	player.y_vel = player.y_vel + (gravity * dt)


	player.x, player.y, cols, len = world:move(player, player.x + (player.x_vel * dt), player.y + (player.y_vel * dt), playerFilter)
	print(len)
	for i=1, len do
		local col = cols[i]
		if cols[i].other.isBlock then
			print("é bloco!!")
			checkIfOnGround(col.normal.y)
		else
			print("n é bloco!!")
		end

	end

	player.animation:update(dt)
	updateSkill(dt)

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

function hitEnemy(enemy, dmg)
	enemy.lifebar = enemy.lifebar - dmg

	if enemy.lifebar < 0 then
		enemy.lifebar = 0
	end
end