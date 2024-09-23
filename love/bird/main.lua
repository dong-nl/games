push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleState'
require 'states/ScoreState'
require 'states/CountDownState'
require 'StateMachine'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_SCROLL_POINT = 413

scrolling = true

function love.load()
	math.randomseed(os.time())

	love.graphics.setDefaultFilter('nearest')

	love.window.setTitle('Fifty Bird')

	push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	smallFont = love.graphics.newFont('font.ttf',8)
	mediumFont = love.graphics.newFont('flappy.ttf',14)
	flappyFont = love.graphics.newFont('flappy.ttf',28)
	hugeFont = love.graphics.newFont('flappy.ttf',56)
	love.graphics.setFont(smallFont)

	sounds = {
		jump = love.audio.newSource('jump.wav','static'),
		explosion = love.audio.newSource('explosion.wav','static'),
		hurt = love.audio.newSource('hurt.wav','static'),
		score = love.audio.newSource('score.wav','static'),
		music = love.audio.newSource('marios_way.mp3','static')
	}

	sounds['music']:setLooping(true)
	sounds['music']:play()

	gStateMachine = StateMachine({
		title = function() return TitleState() end,
		play = function() return PlayState() end,
		score = function() return ScoreState() end,
		countdown = function() return CountDownState() end
	})
	gStateMachine:change('title')

	love.keyboard.keysPressed = {}	

	love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.mousepressed(x,y,button)
	love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
	return love.mouse.buttonsPressed[button]
end

function love.resize(w,h)
	push:resize(w,h)
end

function love.update(dt)
	if scrolling then
		backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_SCROLL_POINT
		groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
	end

	gStateMachine:update(dt)
	

	love.keyboard.keysPressed = {}
	love.mouse.buttonsPressed = {}
end

function love.draw()
	push:start()

	love.graphics.draw(background,-backgroundScroll,0)
	love.graphics.draw(ground,-groundScroll,VIRTUAL_HEIGHT - 16)

	gStateMachine:render()

	push:finish()
end