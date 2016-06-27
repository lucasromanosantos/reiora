local anim8 = require "lib/anim8"

function startEnemy()
	local sprites = love.graphics.newImage("images/reiorafull.png")
	local grid = anim8.newGrid(48, 84, sprites:getWidth(), sprites:getHeight()) --offset

	enemy = {
		lifebar = 100,
		isEnemy = true,
		sprites = sprites,
		x = 350,
		y = 256,
		x_vel = 0,
		y_vel = 0,
		speed = 200,
		jumpspeed = -425,
		w = 48,
		h = 84,
		hit = false,
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
	enemy.animation = enemy.animations.idler

	gravity =  9.81*70
	friction = 10

end

function moveEnemy(dt, world)
	local down = love.keyboard.isDown
	
	local enemyFilter = function(item, other)
		if other.isSkill then return 'slide'
		elseif other.isPlayer then return nil
		else return 'slide'
		end
	end

	enemy.x, enemy.y, enemy_cols, enemy_len = world:move(enemy, enemy.x + (enemy.x_vel * dt), enemy.y + (enemy.y_vel * dt), enemyFilter)
	for i=1, enemy_len do
		local col = enemy_cols[i]
		checkEnemyIfOnGround(col.normal.y)
	end

	enemy.animation:update(dt)

	enemy.y_vel = enemy.y_vel + (gravity * dt)
	if enemy.x_vel < 0 then
		enemy.x_vel = enemy.x_vel + friction
	end
	if enemy.x_vel > 0 then
		enemy.x_vel = enemy.x_vel - friction
	end
end

function checkEnemyIfOnGround(ny)
	if ny < 0 then
		enemy.jumping = false
		enemy.y_vel = 0 --?
	end
end