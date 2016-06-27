local anim8 = require "lib/anim8"

function useSkill()
	local sprites
	if player.facing == "right" then
		sprites = love.graphics.newImage("images/fireball32.png")
	else
		sprites = love.graphics.newImage("images/fireball32-left.png")
	end
	local grid = anim8.newGrid(32, 32, sprites:getWidth(), sprites:getHeight(), 0, 0, 0)
	skill = {
		isSkill = true,
		sprites = sprites,
		x = player.x,
		y = player.y + 15,
		h = 32,
		w = 32,
		facing = player.facing,
		x_vel = 200,
		animations = {
			state1 = anim8.newAnimation(grid('1-1', 1), 0.5)
		}
	}

	if player.facing == "right" then skill.x = skill.x + 30
	else skill.x = skill.x - 30
	end

	skill.animation = skill.animations.state1

 	world:add(skill, skill.x, skill.y, skill.w, skill.h)


	table.insert(player.skills,skill)
end

function updateSkill(dt)
	local cols, len

	local skillFilter = function(item, other)
		if other.isBlock then return nil
		elseif other.isPlayer then return 'cross'
		elseif other.isSkill then return nil
		elseif other.isEnemy then return  'touch'
		else return  nil
		end
	end

	for i,skill in ipairs(player.skills) do
		skill.animation:update(dt)
		if skill.facing == "right" then
			skill.x, skill.y, cols, len = world:move(skill, skill.x + (skill.x_vel * dt), skill.y, skillFilter)
		else
			skill.x, skill.y, cols, len = world:move(skill, skill.x + (skill.x_vel * dt * -1), skill.y, skillFilter)
		end

		for j=1, len do
			local other = cols[j].other
			if other.isEnemy then
				hitEnemy(enemy, 15)
				world:remove(skill)
				table.remove(player.skills, i)
			end
		end
	end
end