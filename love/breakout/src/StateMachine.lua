StateMachine = Class()

function StateMachine:init(states)
	self.empty = {
		enter = function() end,
		exit = function() end,
		update = function() end,
		render = function() end,
	}

	self.current = self.empty
	self.states = states or {}
end

function StateMachine:change(stateName,params)
	assert(self.states[stateName])
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(params)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end