--[[
------------------------------------------------------------------------------------------
 ______                
(_____ \               (_)           
 _____) )___ ___  ____  _  ___  ____ 
|  ____/ ___) _ \|    \| |/___)/ _  )
| |   | |  | |_| | | | | |___ ( (/ / 
|_|   |_|   \___/|_|_|_|_(___/ \____)

- + Description + -----------------------------------------------------------------------
                                       
Promise is a module that provides promises in roblox.
Made fully by Danki(@Dankinations)

You can chain the connections, by the way.

- + Help + ------------------------------------------------------------------------------

✦  Promise States  ✦
Once a Promise enters FAIL/RESOLVED/CANCELLED it cannot change its state.

✦ When passing the callback into Promise.new() it gets 3 useful things(in order) ✦
        
     >>  Resolve(...) <-> Fail(...) <-> CancelSignal : Signal+ Signal  <<



☆ Resolve(...) - Sets the promise state to RESOLVED. The callbacks connected to the
            RESOLVED Promise STATE will get the values passed in.

☆ Fail(...) - Sets the promise state to FAILED. The callbacks connected to the
            FAILED Promise STATE will get the values passed in.

☆ CancelSignal:Fire() - Sets the promise state to CANCELLED. The callbacks connected
            to the CANCELLED Promise STATE will get the values passed in.

- + Functions + ------------------------------------------------------------------------

★  Promise.new(callback)
Returns a new Promise instance

★  Promise:AndThen(callback)   
Runs the callback when the promise exits successfully

★  Promise:Catch(callback)       
Runs the callback when the promise exits unsuccessfully

★  Promise:Finally(callback)     
Runs the callback when the promise exits except if it was cancelled

★  Promise:AndFinally(callback)     
Runs the callback when the promise exits no matter what

★  Promise:Cancelled(callback)   
Runs the callback when the promise gets cancelled

★  Promise:Cancel()   
Cancels the promise

★  Promise:CancelAndDestroy()   
Cancels the promise and destroys it

- + Credits + ---------------------------------------------------------------------------

Signal+ - @AlexanderLindholt

-----------------------------------------------------------------------------------------
]]

local Promise = {}
Promise.__index = Promise
Promise.PromiseStates = { PENDING = "PENDING", RESOLVED = "RESOLVED", FAIL = "FAIL", CANCELLED = "CANCELLED" }

local Signal = require("./Signal")

export type PromiseType<P> = {
	state: number,
	_cancelSignal: Signal.Signal<any>,
	value: P?,
	PromiseStates: { PENDING: number, RESOLVED: number, FAIL: number, CANCELLED: number },
	AndThen: (self: PromiseType<P>, (P) -> nil) -> PromiseType<P>,
	AndFinally: (self: PromiseType<P>, (P) -> nil) -> PromiseType<P>,
	Catch: (self: PromiseType<P>, (P) -> nil) -> PromiseType<P>,
	Finally: (self: PromiseType<P>, (P) -> nil) -> PromiseType<P>,
	Cancelled: (self: PromiseType<P>, () -> nil) -> PromiseType<P>,
	Destroy: (self: PromiseType<P>) -> nil,
	Cancel: (self: PromiseType<P>) -> nil,
	CancelAndDestroy: (self: PromiseType<P>) -> nil,
}

function Promise.new<P>(
	executor: (resolve: (any) -> (), fail: (any) -> (), cancelled: Signal.Signal<any>) -> ()
): PromiseType<any>
	local self = (setmetatable({}, Promise) :: any) :: PromiseType<any>
	self.state = Promise.PromiseStates.PENDING
	self.callbacks = {
		[Promise.PromiseStates.RESOLVED] = {},
		[Promise.PromiseStates.FAIL] = {},
		FINALLY = {},
		ANDFINALLY = {},
		[Promise.PromiseStates.CANCELLED] = {},
	}
	self._cancelSignal = Signal()
	self.value = nil

	local function transition(newState: number, ...)
		if self.state ~= Promise.PromiseStates.PENDING then
			return
		end
		self.state = newState
		self.value = ...

		if self._destroyed then
			return
		end
		for _, callback in self.callbacks[newState] do
			callback(self.value)
		end

		if self._destroyed then
			return
		end
		for _, callback in self.callbacks["FINALLY"] do
			callback(self.value)
		end

		if self._destroyed then
			return
		end
		for _, callback in self.callbacks["ANDFINALLY"] do
			callback(self.value)
		end
	end

	local resolve = function(...)
		transition(Promise.PromiseStates.RESOLVED, ...)
	end

	local fail = function(...)
		transition(Promise.PromiseStates.FAIL, ...)
	end

	task.spawn(function()
		local succ, err = pcall(function(...)
			executor(resolve, fail, self._cancelSignal)
		end)
		if not succ then
			warn("Runtime error | " .. err .. " | " .. debug.traceback("", 4))
			fail("Runtime error")
		end
	end)
	return self
end

-- Executes the function if the promise gives an error
function Promise:Catch<P>(onFail): PromiseType<any>?
	if self._destroyed then
		warn("This promise has been destroyed")
		return
	end

	if self.state == Promise.PromiseStates.FAIL then
		onFail(self.value)
	else
		table.insert(self.callbacks[Promise.PromiseStates.FAIL], onFail)
	end

	return self
end

-- Executes the function if the promise ends successfully
function Promise:AndThen<P>(onSuccess): PromiseType<any>?
	if self._destroyed then
		warn("This promise has been destroyed")
		return
	end

	if self.state == Promise.PromiseStates.RESOLVED then
		onSuccess(self.value)
	else
		table.insert(self.callbacks[Promise.PromiseStates.RESOLVED], onSuccess)
	end
	return self
end

-- Executes the function when the promise ends running except if it was cancelled
function Promise:Finally<P>(onEnd): PromiseType<any>?
	if self._destroyed then
		warn("This promise has been destroyed")
		return
	end

	if self.state ~= Promise.PromiseStates.PENDING and self.state ~= Promise.PromiseStates.CANCELLED then
		onEnd(self.value)
	else
		table.insert(self.callbacks.FINALLY, onEnd)
	end
	return self
end

-- Executes the function when the promise ends running no matter what
function Promise:AndFinally<P>(onEnd): PromiseType<any>?
	if self._destroyed then
		warn("This promise has been destroyed")
		return
	end

	if self.state ~= Promise.PromiseStates.PENDING then
		onEnd(self.value)
	else
		table.insert(self.callbacks.ANDFINALLY, onEnd)
	end
	return self
end

-- Executes the function if the promise is cancelled
function Promise:Cancelled<P>(onCancel): PromiseType<any>?
	if self._destroyed then
		warn("This promise has been destroyed")
		return
	end

	if self.state == Promise.PromiseStates.CANCELLED then
		onCancel()
	elseif self.state == Promise.PromiseStates.PENDING then
		table.insert(self.callbacks[Promise.PromiseStates.CANCELLED], onCancel)
	end
	return self
end

-- Cancels the promise (FINALLY STILL RUNS)
function Promise:Cancel<P>()
	if self.state ~= Promise.PromiseStates.PENDING then
		return
	end
	self.state = Promise.PromiseStates.CANCELLED
	self._cancelSignal:Fire()

	for _, callback in self.callbacks[Promise.PromiseStates.CANCELLED] do
		callback()
	end

	for _, callback in self.callbacks.FINALLY do
		callback(nil)
	end
end

-- Cleans up the promise
function Promise:Destroy()
	if self._destroyed then
		warn("This promise has already been destroyed")
		return
	end

	table.clear(self)
	self._destroyed = true
end

-- pretty easy to understand
function Promise:CancelAndDestroy()
	if self._destroyed then
		warn("This promise has already been destroyed")
		return
	end

	if self.state ~= Promise.PromiseStates.PENDING then
		return
	end
	self.state = Promise.PromiseStates.CANCELLED
	self._cancelSignal:Fire()

	for _, callback in self.callbacks[Promise.PromiseStates.CANCELLED] do
		callback()
	end

	for _, callback in self.callbacks.FINALLY do
		callback(nil)
	end

	task.delay(2, function()
		table.clear(self)
		self._destroyed = true
	end)
end

return Promise
