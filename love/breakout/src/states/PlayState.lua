PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
	self.paddle = params.paddle
	self.ball = params.ball	

	self.ball.dx = math.random(-200,200)
	self.ball.dy = math.random(-50,-60)

	self.bricks = params.bricks
	self.health = params.health
	self.score = params.score
	self.level = params.level
	self.highScores = params.highScores
end

function PlayState:update(dt)
	if self.paused then
		if love.keyboard.wasPressed('space') then
			gSounds['pause']:play()
			self.paused = false
		else
			return
		end
	else
		if love.keyboard.wasPressed('space') then
			gSounds['pause']:play()
			self.paused = true
			return
		end
	end
	self.paddle:update(dt)
	self.ball:update(dt)

	if self.ball:collides(self.paddle) then
		gSounds['paddle-hit']:play()
		self.ball.dy = -self.ball.dy
		self.ball.y = self.paddle.y - 8
		
		if self.ball.x < self.paddle.x + self.paddle.width / 2 and self.paddle.dx < 0 then
			self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
		elseif self.ball.x > self.paddle.x + self.paddle.width / 2 and self.paddle.dx > 0 then
			self.ball.dx = 50 + 8 * (self.ball.x - self.paddle.x + self.paddle.width / 2)
		end
	end

	for k,brick in pairs(self.bricks) do
		if brick.inPlay and self.ball:collides(brick) then
			brick:hit()
			self.score = self.score + brick.tier * 200 + brick.color * 25

			if self:checkVictory() then
				gSounds['victory']:play()

				gStateMachine:change('victory',{
					paddle = self.paddle,
					ball = self.ball,
					health = self.health,
					score = self.score,
					level = self.level,
					highScores = self.highScores
				})
			end

			if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x - 8
			elseif self.ball.x + 6 < brick.x + brick.width and self.ball.dx < 0 then
				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x + 32
			elseif self.ball.y < brick.y then
				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y - 8
			else
				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y + 16
			end

			self.ball.dy = self.ball.dy * 1.03
			break
		end
	end

	if self.ball.y >= VIRTUAL_HEIGHT then
		gSounds['hurt']:play()
		self.health = self.health - 1

		if self.health == 0 then
			gStateMachine:change('game-over',{
				score = self.score,
				highScores = self.highScores
			})
		else
			gStateMachine:change('serve',{
				paddle = self.paddle,
				bricks = self.bricks,
				health = self.health,
				score = self.score,
				level = self.level,
				highScores = self.highScores
			})
		end
	end

	for k,brick in pairs(self.bricks) do
		brick:update(dt)
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function PlayState:render()
	self.paddle:render()
	self.ball:render()

	for k,brick in pairs(self.bricks) do
		brick:render()
	end

	for k,brick in pairs(self.bricks) do
		brick:renderParticle()
	end

	renderHealth(self.health)
	renderScore(self.score)

	if self.paused then
		love.graphics.setFont(gFonts['large'])
		love.graphics.printf('PAUSE',0,VIRTUAL_HEIGHT / 2 - 16,VIRTUAL_WIDTH,'center')
	end
end

function PlayState:checkVictory()
	for k,brick in pairs(self.bricks) do
		if brick.inPlay then
			return false
		end
	end
	return true
end