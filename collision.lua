function startCollision(map)
	love.physics.setMeter(32)

	world = love.physics.newWorld(0, 9.81*70, true)
	collision = map:initWorldCollision(world)
end