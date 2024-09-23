PlayState = Class({__includes = BaseState})

function PlayState:init()
	self.bird = Bird()
	self.pipePairs = {}
	self.timer = 0
	self.lastY = -PIPE_HEIGHT + math.random(80) + 20

	self.score = 0
end

function PlayState:update(dt)
	self.bird:update(dt)

	self.timer = self.timer + dt
	if self.timer > 2 then
		self.timer = 0

		local y = math.max(-PIPE_HEIGHT - 10,math.min(self.lastY + math.random(-20,20),VIRTUAL_HEIGHT - GAPHEIGHT - PIPE_HEIGHT))

		self.lastY = y
		table.insert(self.pipePairs,PipePair(y))
	end

	for k,pair in pairs(self.pipePairs) do
		pair:update(dt)

		if not pair.scored then
			if pair.x + PIPE_WIDTH <= self.bird.x then
				sounds['score']:play()
				pair.scored = true
				self.score = self.score + 1
				gStateMachine:change('score',{score = self.score})
			end
		end

		for j,pipe in pairs(pair.pipes) do
			if self.bird:collides(pipe) then
				sounds['explosion']:play()
				sounds['hurt']:play()
				gStateMachine:change('countdown')
			end
		end
	end

	for k,pair in pairs(self.pipePairs) do
		if pair.remove then
			table.remove(self.pipePairs,k)
		end
	end

	if self.bird.y > VIRTUAL_HEIGHT - 15 then
		sounds['explosion']:play()
		sounds['hurt']:play()
		gStateMachine:change('score',{score = self.score})
	end
end

function PlayState:render()
	self.bird:render()

	love.graphics.setFont(flappyFont)
	love.graphics.print(tostring(self.score),8,8)

	for k,pair in pairs(self.pipePairs) do
		pair:render()
	end
end

function PlayState:enter()
	scrolling = true
end

function PlayState:exit()
	scrolling = false
end