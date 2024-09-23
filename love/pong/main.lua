push = require 'push'
class = require 'class'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
	love.window.setTitle('Pong')
	math.randomseed(os.time())

	love.graphics.setDefaultFilter('nearest')

	smallfont = love.graphics.newFont('font.ttf',8)
	love.graphics.setFont(smallfont)

	largeFont = love.graphics.newFont('font.ttf',16)

	push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	scoreFont = love.graphics.newFont('font.ttf',32)

	player1Score = 0
	player2Score = 0

	require 'Paddle'
	require 'Ball'

	player1 = Paddle(10,30,5,20)
	player2 = Paddle(VIRTUAL_WIDTH - 10,VIRTUAL_HEIGHT - 50,5,20)	

	ball = Ball(VIRTUAL_WIDTH / 2 - 2,VIRTUAL_HEIGHT / 2 - 2,4)

	state = 'start'
	servingPlayer = 1

	sounds = {
		['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
		['score'] = love.audio.newSource('sounds/score.wav','static'),
		['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
	}
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	
	if key == 'enter' or key == 'return' then
		if state == 'start' then
			state = 'serve'
		elseif state == 'serve' then
			state = 'play'	
		elseif state == 'done' then
			state = 'serve'
			
			player1Score = 0
			player2Score = 0

			ball:reset()

			if winningPlayer == 1 then
				servingPlayer = 2
			else
				servingPlayer = 1
			end
		end
	end
end

function love.update(dt)
	if state == 'serve' then
		ball.dy = math.random(-50,50)
		if servingPlayer == 1 then
			ball.dx = math.random(140,200)
		else
			ball.dx = -math.random(140,200)
		end
	elseif state == 'play' then
		ball:update(dt)

		if ball:collides(player1) then
			sounds['paddle-hit']:play()
			ball.dx = -ball.dx * 1.03
			ball.x = player1.x + 9
	
			if ball.dy < 0 then
				ball.dy = -math.random(10,150)
			else
				ball.dy = math.random(10,150)
			end
		end
	
		if ball:collides(player2) then
			sounds['paddle-hit']:play()
			ball.dx = -ball.dx * 1.03
			ball.x = player2.x - 4
	
			if ball.dy < 0 then
				ball.dy = -math.random(10,150)
			else
				ball.dy = math.random(10,150)
			end
		end
	
		if ball.y - 4 < 0 then
			sounds['wall-hit']:play()
			ball.y = 4
			ball.dy = -ball.dy
		end
	
		if ball.y + 4 > VIRTUAL_HEIGHT then
			sounds['wall-hit']:play()
			ball.y = VIRTUAL_HEIGHT - 4
			ball.dy = -ball.dy
		end
	end

	if ball.x - 4 < 0 then
		sounds['score']:play()
		servingPlayer = 1
		player2Score = player2Score + 1

		if player2Score == 10 then
			winningPlayer = 2
			state = 'done'
		else
			ball:reset()
			state = 'serve'	
		end
			
	end

	if ball.x + 4 > VIRTUAL_WIDTH then
		sounds['score']:play()
		servingPlayer = 2
		player1Score = player1Score + 1

		if player1Score == 10 then
			winningPlayer = 1
			state = 'done'
		else
			ball:reset()
			state = 'serve'
		end		
	end

	if love.keyboard.isDown('w') then
		player1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED
	else
		player1.dy = 0
	end

	if love.keyboard.isDown('up') then
		player2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('down') then
		player2.dy = PADDLE_SPEED
	else
		player2.dy = 0
	end	

	player1:update(dt)
	player2:update(dt)	
end

function love.draw()
	push:apply('start')

	love.graphics.clear(40 / 255,42/ 255,45/255,255/255)	
	-- love.graphics.printf('Hello Pong!',0,20,VIRTUAL_WIDTH,'center')

	if state == 'start' then
		love.graphics.setFont(smallfont)
		love.graphics.printf('Welcome to Pong!',0,10,VIRTUAL_WIDTH,'center')
		love.graphics.printf('Press Enter to begin!',0,20,VIRTUAL_WIDTH,'center')	
	elseif state == 'serve' then
		love.graphics.setFont(smallfont)
		love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!",0,10,VIRTUAL_WIDTH,'center')
		love.graphics.printf('Press Enter to serve!',0,20,VIRTUAL_WIDTH,'center')
	elseif state == 'done' then
		love.graphics.setFont(largeFont)
		love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',0,10,VIRTUAL_WIDTH,'center')
		love.graphics.setFont(smallfont)
		love.graphics.printf('Press Enter to serve!',0,30,VIRTUAL_WIDTH,'center')
	end

	ball:draw()
	player1:draw()
	player2:draw()
	    
	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(player1Score),VIRTUAL_WIDTH / 2 - 50,VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(player2Score),VIRTUAL_WIDTH / 2 + 30,VIRTUAL_HEIGHT / 3)

	displayFPS()

	push:apply('end')
end

function love.resize(w,h)
	push:resize(w,h)
end

function displayFPS()
	love.graphics.setFont(smallfont)
	love.graphics.setColor(0,255/255,0,255/255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()),10,10)
end