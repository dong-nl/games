GameOverState = Class {__includes = BaseState}

function GameOverState:enter(params)
	self.score = params.score
	self.highScores = params.highScores
end

function GameOverState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		local highScore = false

		local scoreIndex  = 11

		for i = 10,1,-1 do
			local score = self.highScores[i].score or 0
			if self.score > score then
				scoreIndex = i
				highScore = true
			end
		end

		if highScore then
			gSounds['high-score']:play()
			gStateMachine:change('enter-high-score',{
				score = self.score,
				scoreIndex = scoreIndex,
				highScores = self.highScores
			})
		else
			gStateMachine:change('start',{
				highScores = self.highScores
			})
		end
		
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function GameOverState:render()
	love.graphics.setFont(gFonts['large'])
	love.graphics.printf('Game Over!',0,VIRTUAL_HEIGHT / 3,VIRTUAL_WIDTH,'center')
	love.graphics.setFont(gFonts['medium'])
	love.graphics.printf('Final Score: ' .. tostring(self.score),0,VIRTUAL_HEIGHT / 2,VIRTUAL_WIDTH,'center')
	love.graphics.printf('Press Enter!',0,VIRTUAL_HEIGHT / 4,VIRTUAL_WIDTH,'center')
end