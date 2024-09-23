Ball = class()

function Ball:init(x,y,radius)
	self.x = x
	self.y = y
	self.radius = radius

	self.dx = math.random(2) == 1 and 100 or -100
	self.dy = math.random(-50,50)
end

function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
end

function Ball:draw()
	love.graphics.circle('line',self.x,self.y,self.radius)
end

function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2		
end

function Ball:collides(player)
	if self.x + self.radius < player.x or self.x - self.radius > player.x + player.width then
		return false
	end

	if self.y + self.radius < player.y or self.y - self.radius > player.y + player.height then
		return false
	end

	return true
end