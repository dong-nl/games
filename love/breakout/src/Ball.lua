Ball = Class {}

function Ball:init(skin)
	self.skin = skin	

	self.width = 8
	self.height = 8

	self.dx = 0
	self.dy = 0
end

function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	if self.x <= 0 then
		gSounds['wall-hit']:play()
		self.dx = -self.dx	
		self.x = 0
	end

	if self.x >= VIRTUAL_WIDTH - 8 then
		gSounds['wall-hit']:play()
		self.dx = -self.dx	
		self.x = VIRTUAL_WIDTH - 8
	end

	if self.y <= 0 then
		gSounds['wall-hit']:play()
		self.dy = -self.dy
		self.y = 0
	end
end

function Ball:render()
	love.graphics.draw(gTextures['main'],gFrames['balls'][self.skin],self.x,self.y)
end

function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2 - 4
	self.y = VIRTUAL_HEIGHT - 42		

	self.dx = 0
	self.dy = 0
end

function Ball:collides(target)
	if self.x + self.width < target.x or self.x > target.x + target.width then
		return false
	end

	if self.y + self.height < target.y or self.y > target.y + target.height then
		return false
	end

	return true
end