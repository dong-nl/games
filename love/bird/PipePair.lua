PipePair = Class()

GAPHEIGHT = 90

function PipePair:init(y)
	self.x = VIRTUAL_WIDTH + 32
	self.y = y
	self.remove = false

	self.pipes = {
		['top'] = Pipe('top',self.y),
		['bottom'] = Pipe('bottom',self.y + GAPHEIGHT + PIPE_HEIGHT)
	}

	self.scored = false
end

function PipePair:update(dt)
	if self.x < -PIPE_WIDTH then
		remove = true
	else
		self.x = self.x + PIPE_SCROLL * dt
		self.pipes['top'].x = self.x
		self.pipes['bottom'].x = self.x
	end
end

function PipePair:render()
	for k,pipe in pairs(self.pipes) do
		pipe:render()
	end
end