StateMachine = Class()

function StateMachine:init(states)
	self.empty = {
		exit = function() end,
		enter = function() end,
		update = function() end,
		render = function() end
	}

	self.states = states or {}
	self.currentState = self.empty
end

function StateMachine:change(state,enterParams)
	assert(self.states[state])
	self.currentState:exit()
	self.currentState = self.states[state]()
	self.currentState:enter(enterParams)
end

function StateMachine:update(dt)
	self.currentState:update(dt)
end

function StateMachine:render()
	self.currentState:render()
end