class Timer
	Waiting = 0
	Inspecting = 1
	Ready = 2
	Running = 3
	Delay = 4

	constructor: (@ui) ->
		@state = Waiting
		@running_fn = => @ui.running_fn() @get_time()
		@use_inspection = false
		@inspection_count = 15

	set_inspection: =>
		@ui.inspecting_fn() @inspection_count--
		@inspection_timer = setTimeout @set_inspection, 1000

	set_running: ->
		@start_time = new Date().getTime()
		@state = Running
		@solve = null
		if @use_inspection
			clearTimeout @inspection_timer
		@running_timer = setInterval @running_fn, 10

	set_stopped: ->
		@end_time = new Date().getTime()
		clearInterval @running_timer
		@solve = {'time': @end_time}

		if @use_inspection && @inspection_count < 0
			if @inspection_count >= -2
				@solve['plus_two'] = true
			else
				@solve['DNF'] = true
		@inspection_count = 15

		@ui.on_stop()
				
		@state = Delay
		setTimeout (=> @state = Waiting), 500

	trigger_down: =>
		if (@state == Waiting && !@use_inspection) || @state == Inspecting
			@state = Ready
		else if @state == Running
			@set_stopped()

	trigger_up: =>
		if @use_inspection && @state == Waiting
			@state = Inspecting
			@set_inspection()
		else if @state == Ready
			@set_running()
		
	get_time: ->
		new Date().getTime() - @start_time

	get_solve: ->
		@solve
