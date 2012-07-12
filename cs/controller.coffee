class Controller
	constructor: ->
		@ui = new UI
		@shortcuts = new Shortcuts
		@timer = new Timer @
		@session = new Session

		@shortcuts.add_down Shortcuts.space, {fn: @timer.trigger_down}
		@shortcuts.add_up Shortcuts.space, {fn: @timer.trigger_up}

	on_stop: ->
		@session.add @timer.get_solve()

	running_fn: => @ui.running_fn
	inspection_fn: => @ui.inspecting_fn

window.onload = ->
	window.c = new Controller()
