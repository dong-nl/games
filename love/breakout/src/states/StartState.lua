StartState = Class{__includes = BaseState}

local heighLighed = 1

function StartState:update()
	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

	if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
		heighLighed = heighLighed == 1 and 2 or 1
		gSounds['paddle-hit']:play()
	end

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		if heighLighed == 1 then
			gSounds['confirm']:play()
			gStateMachine:change('serve',{
				paddle = Paddle(1),
				bricks = LevelMaker.createMap(1),
				health = 3,
				score = 0
			})
		end
	end
end

function StartState:render()
	love.graphics.setFont(gFonts['large'])
	love.graphics.printf('BREAKOUT',0,VIRTUAL_HEIGHT / 3,VIRTUAL_WIDTH,'center')

	love.graphics.setFont(gFonts['medium'])
	if heighLighed == 1 then
		love.graphics.setColor(103/255,1,1,1)
	end
	love.graphics.printf('START',0,VIRTUAL_HEIGHT / 2 + 70,VIRTUAL_WIDTH,'center')

	love.graphics.setColor(1,1,1,1)
	if heighLighed == 2 then
		love.graphics.setColor(103/255,1,1,1)
	end
	love.graphics.printf('HIGH SCORE',0,VIRTUAL_HEIGHT / 2 + 90,VIRTUAL_WIDTH,'center')

	love.graphics.setColor(1,1,1,1)
end